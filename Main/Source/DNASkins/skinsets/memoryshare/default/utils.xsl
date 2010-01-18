<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<!--
		returns:
			0: no date
			1: specific date
			2: date range
			3: fuzzy date
	-->
	<xsl:template name="GET_DATE_RANGE_TYPE">	
		<xsl:param name="startdate"></xsl:param>
		<xsl:param name="startday">0</xsl:param>
		<xsl:param name="startmonth">0</xsl:param>
		<xsl:param name="startyear">0</xsl:param>
		<xsl:param name="enddate"></xsl:param>
		<xsl:param name="endday">0</xsl:param>
		<xsl:param name="endmonth">0</xsl:param>
		<xsl:param name="endyear">0</xsl:param>
		<xsl:param name="timeinterval"></xsl:param>
		
		<!-- xsl:variable name="is_next_day">
			<xsl:call-template name="IS_NEXT_DAY">
				<xsl:with-param name="startdate" select="$startdate"/>
				<xsl:with-param name="startday" select="$startday"/>
				<xsl:with-param name="startmonth" select="$startmonth"/>
				<xsl:with-param name="startyear" select="$startyear"/>
				<xsl:with-param name="enddate" select="$enddate"/>
				<xsl:with-param name="endday" select="$endday"/>
				<xsl:with-param name="endmonth" select="$endmonth"/>
				<xsl:with-param name="endyear" select="$endyear"/>
			</xsl:call-template>
		</xsl:variable -->

		<xsl:choose>
			<xsl:when test="$startyear = '' and $endyear = '' and $startmonth = '' and $endmonth = '' and $startday = '' and $endday = ''">0</xsl:when><!-- Nonsense date passed in so return 0 (no date).-->
			<xsl:when test="( ($startyear = $endyear and $startmonth = $endmonth and $endday = $startday) and not($startyear = 0 and $endyear = 0 and $startmonth = 0 and $endmonth = 0 and $endday = 0 and $startday = 0)) or ( $startday != 0 and $startday != '' and ($endday = 0 or $endday = '')) or ($startdate = $enddate and not($startdate = '' and $enddate = ''))">1</xsl:when>
			<xsl:when test="$timeinterval &gt; 0">3</xsl:when>
			<xsl:when test="($startdate != '') or ($startday != '' and $startday != 0)">2</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template name="GET_DAYS_IN_RANGE">
		<xsl:param name="startdate"></xsl:param>
		<xsl:param name="startday"></xsl:param>
		<xsl:param name="startmonth"></xsl:param>
		<xsl:param name="startyear"></xsl:param>
		<xsl:param name="enddate"></xsl:param>
		<xsl:param name="endday"></xsl:param>
		<xsl:param name="endmonth"></xsl:param>
		<xsl:param name="endyear"></xsl:param>
		
		<xsl:variable name="startday_n">
			<xsl:choose>
				<xsl:when test="$startdate and $startdate != '' and $startday=0">
					<xsl:value-of select="substring-before($startdate, $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startday"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="startmonth_n">
			<xsl:choose>
				<xsl:when test="$startdate and $startdate != '' and $startmonth=0">
					<xsl:value-of select="substring-before(substring-after($startdate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startmonth"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="startyear_n">
			<xsl:choose>
				<xsl:when test="$startdate and $startdate != '' and $startyear=0">
					<xsl:value-of select="substring-after(substring-after($startdate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startyear"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endday_n">
			<xsl:choose>
				<xsl:when test="$enddate and $enddate != '' and $endday=0">
					<xsl:value-of select="substring-before($enddate, $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$endday"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endmonth_n">
			<xsl:choose>
				<xsl:when test="$enddate and $enddate != '' and $endmonth=0">
					<xsl:value-of select="substring-before(substring-after($enddate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$endmonth"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endyear_n">
			<xsl:choose>
				<xsl:when test="$enddate and $enddate != '' and $endyear=0">
					<xsl:value-of select="substring-after(substring-after($enddate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$endyear"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<!-- if startdate is 0, assume this is a no-date -->
			<xsl:when test="$startday_n=0 or not($startday_n)">0</xsl:when>

			<!-- in extrainfo enddate might be 0, assume this is a specific date -->  
			<xsl:when test="$endday_n=0 and $endmonth_n=0 and $endyear_n=0">1</xsl:when>
			
			<!-- a range within the same year -->
			<xsl:when test="$startyear_n = $endyear_n">
				<xsl:choose>
					<xsl:when test="$startmonth_n = $endmonth_n">
						<xsl:value-of select="$endday_n - $startday_n" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="month_diff">
							<xsl:call-template name="GET_DAYS_IN_MONTH_RANGE">
								<xsl:with-param name="startmonth" select="$startmonth_n + 1" />
								<xsl:with-param name="endmonth" select="$endmonth_n" />
								<xsl:with-param name="year" select="$startyear_n"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="remaining_days">
							<xsl:call-template name="GET_REMAING_IN_DAYS_IN_MONTH">
								<xsl:with-param name="startday" select="$startday_n" />
								<xsl:with-param name="startmonth" select="$startmonth_n" />
								<xsl:with-param name="year" select="$startyear_n"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$month_diff + $remaining_days + $endday_n" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				
			</xsl:otherwise>	
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="GET_DAYS_IN_MONTH_RANGE">
		<xsl:param name="startmonth"/>
		<xsl:param name="endmonth"/>
		<xsl:param name="year"/>
		<xsl:param name="ret">0</xsl:param>
			
		<xsl:variable name="isLeapYear" select="($year mod 4 = 0 and $year mod 100 != 0) or $year mod 400 = 0"/>
		<!--[FIXME: why doesn't this work?]
			<xsl:call-template name="IS_LEAP_YEAR">
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>
		-->

		<xsl:choose>
			<xsl:when test="$startmonth &lt; $endmonth">
				<xsl:call-template name="GET_DAYS_IN_MONTH_RANGE">
					<xsl:with-param name="startmonth" select="$startmonth + 1"/>
					<xsl:with-param name="endmonth" select="$endmonth"/>
					<xsl:with-param name="ret">
						<xsl:choose>		
							<xsl:when test="$isLeapYear and ($startmonth = 2)">29</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$ret + msxsl:node-set($months)/list/item[@m=number($startmonth)]/@days"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$ret"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="GET_REMAING_IN_DAYS_IN_MONTH">
		<xsl:param name="startday" />
		<xsl:param name="startmonth" />
		<xsl:param name="year"/>
		
		<xsl:variable name="isLeapYear" select="($year mod 4 = 0 and $year mod 100 != 0) or $year mod 400 = 0"/>
		<!--[FIXME: why doesn't this work?]
			<xsl:call-template name="IS_LEAP_YEAR">
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>
		-->
		<xsl:choose>
			<xsl:when test="$isLeapYear and ($startmonth = 2)"><xsl:value-of select="29 - ($startday - 1)"/></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="msxsl:node-set($months)/list/item[@m=number($startmonth)]/@days - ($startday - 1)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="IS_LEAP_YEAR">
		<xsl:param name="year"/>
		<xsl:choose>
			<xsl:when test="($year mod 4 = 0 and $year mod 100 != 0) or $year mod 400 = 0">yes</xsl:when>
			<xsl:otherwise>no</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="CALCULATE_NEAREST_DECADE">
		<xsl:param name="startyear"/>
		<xsl:param name="endyear"/>
		
		<xsl:choose>
			<xsl:when test="$endyear">
				<xsl:variable name="startyear_decade" select="$startyear - ($startyear mod 10)"/>
				<xsl:variable name="endyear_decade" select="$endyear - ($endyear mod 10)"/>
				<xsl:choose>
					<xsl:when test="$startyear_decade = $endyear_decade">
						<xsl:value-of select="$startyear_decade"/>
					</xsl:when>
					<!-- otherwise there is no single decade for this date range-->
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$startyear - ($startyear mod 10)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="IS_NEXT_DAY">
		<xsl:param name="startdate"></xsl:param>
		<xsl:param name="startday"></xsl:param>
		<xsl:param name="startmonth"></xsl:param>
		<xsl:param name="startyear"></xsl:param>
		<xsl:param name="enddate"></xsl:param>
		<xsl:param name="endday"></xsl:param>
		<xsl:param name="endmonth"></xsl:param>
		<xsl:param name="endyear"></xsl:param>
		
		<xsl:variable name="startday_n">
			<xsl:choose>
				<xsl:when test="$startdate and $startdate != '' and $startday=0">
					<xsl:value-of select="substring-before($startdate, $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startday"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="startmonth_n">
			<xsl:choose>
				<xsl:when test="$startdate and $startdate != '' and $startmonth=0">
					<xsl:value-of select="substring-before(substring-after($startdate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startmonth"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="startyear_n">
			<xsl:choose>
				<xsl:when test="$startdate and $startdate != '' and $startyear=0">
					<xsl:value-of select="substring-after(substring-after($startdate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startyear"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endday_n">
			<xsl:choose>
				<xsl:when test="$enddate and $enddate != '' and $endday=0">
					<xsl:value-of select="substring-before($enddate, $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$endday"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endmonth_n">
			<xsl:choose>
				<xsl:when test="$enddate and $enddate != '' and $endmonth=0">
					<xsl:value-of select="substring-before(substring-after($enddate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$endmonth"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endyear_n">
			<xsl:choose>
				<xsl:when test="$enddate and $enddate != '' and $endyear=0">
					<xsl:value-of select="substring-after(substring-after($enddate, $date_sep), $date_sep)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$endyear"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isLeapYear">
			<xsl:call-template name="IS_LEAP_YEAR">
				<xsl:with-param name="year" select="$startyear_n"/>
			</xsl:call-template>
		</xsl:variable>
			
		<xsl:variable name="year_boundary" select="$startmonth_n=12 and $startday_n=31"/>
		
		<xsl:variable name="month_boundary">
			<xsl:choose>
				<xsl:when test="isLeapYear = 'yes' and $startmonth_n = 2">29</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$startday_n = msxsl:node-set($months)/list/item[@m=number($startmonth_n)]/@days"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$startyear_n = $endyear_n and $startmonth_n = $endmonth_n and $startday_n = ($endday_n - 1)">
				<xsl:text>yes</xsl:text>
			</xsl:when>
			<!-- case where falls on month boundary -->
			<xsl:when test="$month_boundary and $startyear_n = $endyear_n and $startmonth_n = ($endmonth_n - 1) and $endday_n = 1">
				<xsl:text>yes</xsl:text>
			</xsl:when>
			<!-- case where falls on year boundary -->
			<xsl:when test="$year_boundary and $startyear_n = ($endyear_n - 1) and $endmonth_n = 1 and $endday_n = 1">
				<xsl:text>yes</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>no</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="COUNT_UP">
		<xsl:param name="from" select="0"/>
		<xsl:param name="to" select="1"/>
		<xsl:param name="inc" select="1"/>
		
		<item><xsl:value-of select="$from"/></item>
		<xsl:if test="($from + $inc) &lt; $to">
			<xsl:call-template name="COUNT_UP">
				<xsl:with-param name="from" select="$from + $inc"/>
				<xsl:with-param name="to" select="$to"/>
				<xsl:with-param name="inc" select="$inc"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	
	<xsl:template name="COUNT_DOWN">
		<xsl:param name="from" select="1"/>
		<xsl:param name="to" select="0"/>
		<xsl:param name="inc" select="1"/>
		
		<item><xsl:value-of select="$from"/></item>
		<xsl:if test="($from - $inc) &gt; $to">
			<xsl:call-template name="COUNT_DOWN">
				<xsl:with-param name="from" select="$from - $inc"/>
				<xsl:with-param name="to" select="$to"/>
				<xsl:with-param name="inc" select="$inc"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="GENERATE_DAY_OPTIONS">
		<xsl:param name="selectedValue"/>
		
		<option value="0">DD</option>
		<xsl:for-each select="msxsl:node-set($days)/list/item">
			<option>
				<xsl:if test="$selectedValue = ./text()">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="GENERATE_MONTH_OPTIONS">
		<xsl:param name="selectedValue"/>
		<xsl:param name="noDefault"/>
		
		<xsl:if test="not($noDefault)">
			<option value="0">Month</option>
		</xsl:if>
		<xsl:for-each select="msxsl:node-set($months)/list/item">
			<option value='{@m}'>
				<xsl:if test="number($selectedValue) = @m">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>
	
	<!-- DROP DOWNS FOR BROWSE DATE DRILL-DOWN INTERFACE -->
	<xsl:template name="DD_GENERATE_DECADE_OPTIONS_DUMB">
		<xsl:param name="y">1900</xsl:param>
		<xsl:param name="max">2010</xsl:param>
		<xsl:param name="selectedValue"/>
		
		<option value="{$y}">
			<xsl:if test="$y = $selectedValue">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$y"/>s
		</option>
		
		<xsl:if test="$y &lt; $max">
			<xsl:call-template name="DD_GENERATE_DECADE_OPTIONS_DUMB">
				<xsl:with-param name="y" select="$y + 10"/>
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="selectedValue" select="$selectedValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="DD_GENERATE_DECADE_OPTIONS">
		<xsl:param name="last"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:call-template name="DD_GENERATE_DECADE_OPTIONS_EXEC">
			<xsl:with-param name="n">1900</xsl:with-param>
			<xsl:with-param name="last" select="$last"/>
			<xsl:with-param name="selectedValue" select="$selectedValue"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_DECADE_OPTIONS_EXEC">
		<xsl:param name="n">1900</xsl:param>
		<xsl:param name="last"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:if test="$n &lt; $last">
			<option value="{$n}">
				<xsl:if test="$n = $selectedValue">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$n"/>s
			</option>
			<xsl:call-template name="DD_GENERATE_DECADE_OPTIONS_EXEC">
				<xsl:with-param name="n" select="$n + 10"/>
				<xsl:with-param name="last" select="$last"/>
				<xsl:with-param name="selectedValue" select="$selectedValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="GET_DECADE_FROM_YEAR">
		<xsl:param name="year"/>
		<xsl:choose>
			<xsl:when test="($year mod 10) = 0">
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($year - ($year mod 10)) + 10"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_YEAR_OPTIONS_DUMB">
		<xsl:param name="y">1900</xsl:param>
		<xsl:param name="max">2010</xsl:param>
		<xsl:param name="selectedValue"/>
		
		<option value="{$y}">
			<xsl:if test="$y = $selectedValue">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$y"/>
		</option>
		
		<xsl:if test="$y &lt; $max">
			<xsl:call-template name="DD_GENERATE_YEAR_OPTIONS_DUMB">
				<xsl:with-param name="y" select="$y + 1"/>
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="selectedValue" select="$selectedValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_YEAR_OPTIONS">
		<xsl:param name="decade"/>
		<xsl:param name="max"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:variable name="last">
			<xsl:choose>
				<xsl:when test="$decade + 9 &gt; $max">
					<xsl:value-of select="$max"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$decade + 9"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="DD_GENERATE_YEAR_OPTIONS_EXEC">
			<xsl:with-param name="n" select="$decade"/>
			<xsl:with-param name="last" select="$last"/>
			<xsl:with-param name="selectedValue" select="$selectedValue"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_YEAR_OPTIONS_EXEC">
		<xsl:param name="n"/>
		<xsl:param name="last"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:if test="$n &lt;= $last">
			<option value="{$n}">
				<xsl:if test="$n = $selectedValue">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$n"/>
			</option>
			<xsl:call-template name="DD_GENERATE_YEAR_OPTIONS_EXEC">
				<xsl:with-param name="n" select="$n + 1"/>
				<xsl:with-param name="last" select="$last"/>
				<xsl:with-param name="selectedValue" select="$selectedValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="DD_GENERATE_MONTH_OPTIONS_DUMB">
		<xsl:param name="selectedValue"/>
		
		<xsl:call-template name="GENERATE_MONTH_OPTIONS">
			<xsl:with-param name="selectedValue" select="$selectedValue"/>
			<xsl:with-param name="noDefault">1</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_MONTH_OPTIONS">
		<xsl:param name="year"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:call-template name="GENERATE_MONTH_OPTIONS">
			<xsl:with-param name="selectedValue" select="$selectedValue"/>
			<xsl:with-param name="noDefault">1</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template name="DD_GENERATE_DAY_OPTIONS_DUMB">
		<xsl:param name="y">1</xsl:param>
		<xsl:param name="max">31</xsl:param>
		<xsl:param name="selectedValue"/>
		
		<option value="{$y}">
			<xsl:if test="$y = $selectedValue">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$y"/>
		</option>
		
		<xsl:if test="$y &lt; $max">
			<xsl:call-template name="DD_GENERATE_DAY_OPTIONS_DUMB">
				<xsl:with-param name="y" select="$y + 1"/>
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="selectedValue" select="$selectedValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_DAY_OPTIONS">
		<xsl:param name="year"/>
		<xsl:param name="month"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:variable name="isLeapYear">
			<xsl:call-template name="IS_LEAP_YEAR">
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:call-template name="DD_GENERATE_DAY_OPTIONS_EXEC">
			<xsl:with-param name="n">1</xsl:with-param>
			<xsl:with-param name="last">
				<xsl:choose>
					<xsl:when test="$month=2 and $isLeapYear= 'yes'">
						<xsl:value-of select="msxsl:node-set($months)/list/item[@m=number($month)]/@days + 1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="msxsl:node-set($months)/list/item[@m=number($month)]/@days"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="selectedValue" select="$selectedValue"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="DD_GENERATE_DAY_OPTIONS_EXEC">
		<xsl:param name="n"/>
		<xsl:param name="last"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:if test="$n &lt;= $last">
			<option value="{$n}">
				<xsl:if test="$n = $selectedValue">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$n"/>
			</option>
			<xsl:call-template name="DD_GENERATE_DAY_OPTIONS_EXEC">
				<xsl:with-param name="n" select="$n + 1"/>
				<xsl:with-param name="last" select="$last"/>
				<xsl:with-param name="selectedValue" select="$selectedValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- 
		combined i.e. both prefixed and non-prefixed values
	-->
	<xsl:template name="GENERATE_COMBINED_LOCATION_OPTIONS">
		<xsl:param name="selectedValue"/>
		
		<option value="" class="nulloption">Please select</option>
		<xsl:for-each select="msxsl:node-set($locations)/list/item">
			<option>
				<xsl:variable name="prefixed_value">
					<xsl:call-template name="PREFIX_WORDS">
						<xsl:with-param name="value" select="@value" />
						<xsl:with-param name="prefix" select="$location_keyword_prefix"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="@value">
					<xsl:choose>
						<xsl:when test="@value = 'null'">
							<xsl:attribute name="value"></xsl:attribute>
							<xsl:attribute name="class">nulloption</xsl:attribute>
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value">
								<xsl:value-of select="concat($prefixed_value, ' ', @value)"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="contains($selectedValue, $prefixed_value) and @value != ''">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</option>
			<xsl:if test="@value = 'null'">
				<option value="" class="nulloption" disabled="disabled">------------------------</option>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>	


	<xsl:template name="GENERATE_PREFIXED_LOCATION_OPTIONS">
		<xsl:param name="selectedValue"/>
		
		<option value="" class="nulloption">Please select</option>
		<xsl:for-each select="msxsl:node-set($locations)/list/item">
			<option>
				<xsl:variable name="prefixed_value">
					<xsl:call-template name="PREFIX_WORDS">
						<xsl:with-param name="value" select="@value" />
						<xsl:with-param name="prefix" select="$location_keyword_prefix"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="@value">
					<xsl:choose>
						<xsl:when test="@value = 'null'">
							<xsl:attribute name="value"></xsl:attribute>
							<xsl:attribute name="class">nulloption</xsl:attribute>
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value">
								<xsl:value-of select="$prefixed_value"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="(contains($selectedValue, $prefixed_value) or contains($selectedValue, text())) and @value != ''">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</option>
			<xsl:if test="@value = 'null'">
				<option value="" class="nulloption" disabled="disabled">------------------------</option>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>	


	<xsl:template name="GENERATE_LOCATION_OPTIONS">
		<xsl:param name="selectedValue"/>

		<option value="" class="nulloption">Please select</option>
		<xsl:for-each select="msxsl:node-set($locations)/list/item">
			<option>
				<xsl:choose>
					<xsl:when test="@value = 'null'">
						<xsl:attribute name="value"></xsl:attribute>
						<xsl:attribute name="class">nulloption</xsl:attribute>
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="value">
							<xsl:value-of select="@value"/>
						</xsl:attribute>
						<xsl:if test="contains($selectedValue, @value) or contains($selectedValue, .)">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="."/>
			</option>
			<xsl:if test="@value = 'null'">
				<option value="" class="nulloption" disabled="disabled">------------------------</option>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>	

	<!-- 
		prefix the given word with the given prefix
		takes into account that the given word could in fact be several words;
		each individual word is prefixed.
	-->
	<xsl:template name="PREFIX_WORDS">
		<xsl:param name="value"/>
		<xsl:param name="prefix"/>
		
		<xsl:variable name="ret">
			<xsl:call-template name="PREFIX_WORDS_EXEC">
				<xsl:with-param name="value" select="$value"/>
				<xsl:with-param name="prefix" select="$prefix"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($prefix, $ret)"/>
	</xsl:template>
	
	<xsl:template name="PREFIX_WORDS_EXEC">
		<xsl:param name="value"/>
		<xsl:param name="prefix"/>
		
		<xsl:choose>
			<xsl:when test="contains($value, ' ')">
				<xsl:choose>
					<xsl:when test="substring($value, 1, 1) = ' '">
						<xsl:value-of select="concat(' ', $prefix)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($value, 1, 1)"/>
					</xsl:otherwise>
				</xsl:choose>
					
				<xsl:call-template name="PREFIX_WORDS_EXEC">
					<xsl:with-param name="value" select="substring($value, 2)"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
		remove everything from the begining of the input parameter
		up to and including the first $keyword_prefix_delim character
	-->
	<!--
	<xsl:template name="STRIP_PREFIX">
		<xsl:param name="phrase"/>
		
		<xsl:choose>
			<xsl:when test="starts-with($phrase, $keyword_prefix_delim)">
				<xsl:value-of select="substring-after($phrase, $keyword_prefix_delim)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="STRIP_PREFIX">
					<xsl:with-param name="phrase" select="substring($phrase, 1)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	-->
	<xsl:template name="STRIP_PREFIX">
		<xsl:param name="phrase"/>
		
		<xsl:if test="starts-with($phrase, $keyword_prefix_prelim) and contains($phrase, $keyword_prefix_delim)">
			<xsl:value-of select="substring-after($phrase, $keyword_prefix_delim)"/>
		</xsl:if>
	</xsl:template>	

	<!--[FIXME: this assumes that prefixed words are all together in the input string, 
	    rather than mixed up with non-prefixed words]
	-->
	<xsl:template name="STRIP_PREFIXED_WORDS">
		<xsl:param name="words"/>
		
		<xsl:choose>
			<xsl:when test="contains($words, $keyword_prefix_delim)">
				<xsl:call-template name="STRIP_PREFIXED_WORDS">
					<xsl:with-param name="words" select="substring-after(substring-after($words, $keyword_prefix_delim), ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$words"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="GENERATE_OPTIONS">
		<xsl:param name="list"/>
		<xsl:param name="selectedValue"/>
		
		<xsl:for-each select="msxsl:node-set($list)/list/item">
			<option>
				<xsl:if test="@value">
					<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
				</xsl:if>
				<xsl:if test="$selectedValue = @value or $selectedValue = text()">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>

	<!-- code to covert urls to links -->	
	<xsl:variable name="url_prefix">http://</xsl:variable>
	<xsl:variable name="links_max_length">28</xsl:variable>
	
	<xsl:template match="text()" mode="convert_urls_to_links" priority="1.0">
		<xsl:variable name="ret">
			<xsl:call-template name="CONVERT_URLS_TO_LINKS">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy-of select="msxsl:node-set($ret)"/>
	</xsl:template>
	<xsl:template match="LINK | A | a" mode="convert_urls_to_links" priority="1.0">
		<xsl:apply-templates select="." />
	</xsl:template>
	<xsl:template match="@*|node()" mode="convert_urls_to_links">
		<xsl:copy>	
			<xsl:apply-templates select="@*|node()" mode="convert_urls_to_links"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="CONVERT_URLS_TO_LINKS">
		<xsl:param name="text"/>
		
		<xsl:choose>
			<xsl:when test="contains($text, $url_prefix)">
				<xsl:variable name="pre_text">
					<xsl:call-template name="CONVERT_URLS_TO_LINKS">
						<xsl:with-param name="text">
							<xsl:value-of select="substring-before($text, $url_prefix)"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="url">
					<xsl:choose>
						<xsl:when test="contains(concat($url_prefix, substring-after($text, $url_prefix)), ' ')">
							<xsl:value-of select="substring-before(concat($url_prefix, substring-after($text, $url_prefix)), ' ')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($url_prefix, substring-after($text, $url_prefix))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="post_text">
					<xsl:call-template name="CONVERT_URLS_TO_LINKS">
						<xsl:with-param name="text">
                            				
							<xsl:value-of select="substring-after(concat($url_prefix, substring-after($text, $url_prefix)), ' ')"/>
                            				
                            				<!--
                        				<xsl:call-template name="GET_REST_WORDS">
                        			    		<xsl:with-param name="text" select="concat($url_prefix, substring-after($text, $url_prefix))"/>
							</xsl:call-template>
							-->
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="target">
					<xsl:choose>
						<xsl:when test="contains($url, 'bbc.co.uk')">_self</xsl:when>
						<xsl:otherwise>_blank</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="label">
					<xsl:call-template name="TRUNCATE_TEXT">
						<xsl:with-param name="text" select="$url"/>
						<xsl:with-param name="new_length" select="$links_max_length"/>
						<xsl:with-param name="start_from">8</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:copy-of select="msxsl:node-set($pre_text)"/>
				<xsl:text> </xsl:text>
				<a href="{$url}" target="{$target}"><xsl:value-of select="$label"/></a>
                		<xsl:text> </xsl:text>
				<xsl:copy-of select="msxsl:node-set($post_text)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
    <xsl:template name="GET_FIRST_WORD">
        <xsl:param name="text"/>
        <xsl:param name="ret"/>

        <xsl:choose>
            <xsl:when test="starts-with($text, ' ') or starts-with($text, '&#xA;') or starts-with($text, '&#xD;') or string-length($text)=0">
                <xsl:value-of select="$ret"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="GET_FIRST_WORD">
                    <xsl:with-param name="text" select="substring($text, 2)"/>
                    <xsl:with-param name="ret" select="concat($ret, substring($text, 1, 1))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
    <xsl:template name="GET_REST_WORDS">
        <xsl:param name="text"/>

        <xsl:choose>
            <xsl:when test="starts-with($text, ' ') or starts-with($text, '&#xA;') or starts-with($text, '&#xD;') or string-length($text)=0">
                <xsl:value-of select="$text"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="GET_REST_WORDS">
                    <xsl:with-param name="text" select="substring($text, 2)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template name="TRUNCATE_TEXT">
		<xsl:param name="text"/>
		<xsl:param name="new_length"/>
		<xsl:param name="start_from">0</xsl:param>
		
		<xsl:variable name="ret">
			<xsl:choose>
				<xsl:when test="string-length($text) &gt; ($start_from + $new_length)">
					<xsl:value-of select="substring($text, $start_from, $new_length)"/>
					<xsl:text>...</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($text, $start_from)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$ret"/>
	</xsl:template>
	
	<!-- 
		DATE FIELDS
		[FIXME: does this have to be duplicated in articlesearch?
		is there some way consolidate the two?]
		
		works for either:
			day, month, year
		or
			datestring
		
		in that order.
		
	-->
	<xsl:template name="DATEFIELDS_SPECIFIC">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="startname">startdate</xsl:param>
		<xsl:param name="validationMsg"/>
		
		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<fieldset>
			<legend>Specific date</legend>
			<label for="specDate">Date (e.g. 25/10/1976)</label>
			<input type="hidden" name="timeinterval" value="1"/>
			<input type="text" name="{$startname}" id="specDate" value="{$startDateString}" maxlength="10" class="txt"/><br/>
		</fieldset>
	</xsl:template>
	
	<!-- output a javascript string variable containing the html for the date field,
	     suitable for e.g. document.write() to insert into the page.
	-->
	<xsl:template name="DATEFIELDS_SPECIFIC_JS_STR">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="startname">startdate</xsl:param>
		<xsl:param name="validationMsg"/>
		
		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>var datefieldsJsHtmlSpecific = '</xsl:text>
		<fieldset>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlSpecific += '</xsl:text>
			<legend>Specific date</legend>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlSpecific += '</xsl:text>
			<label for="specDate">Date (e.g. 25/10/1976) </label>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlSpecific += '</xsl:text>
				<input type="hidden" name="timeinterval" value="1"/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlSpecific += '</xsl:text>
				<input type="text" name="{$startname}" id="specDate" value="{$startDateString}" maxlength="10" class="txt"/><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlSpecific += '</xsl:text>
		</fieldset>
		<xsl:text>'; </xsl:text>
	</xsl:template>

	<xsl:template name="DATEFIELDS_DATERANGE">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="enddate"/>
		<xsl:param name="endday"/>
		<xsl:param name="endmonth"/>
		<xsl:param name="endyear"/>
		<xsl:param name="datesearchtype"/>
		<xsl:param name="startname">startdate</xsl:param>
		<xsl:param name="endname">enddate</xsl:param>
		<xsl:param name="validationMsg"/>

		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endDateString">
			<xsl:choose>
				<xsl:when test="$enddate and $endday=0">
					<xsl:value-of select="$enddate"/>
				</xsl:when>
				<xsl:when test="$endday and not($endday=0)">
					<xsl:value-of select="$endday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<fieldset>
			<legend>Date range</legend>
			<div>
				<label for="dateFrom">Date from (e.g. 01/09/1975)</label><br/>
				<input type="text" name="{$startname}" id="dateFrom" value="{$startDateString}" maxlength="10" class="txt"/>
			</div>

			<div>
				<label for="dateTo">Date to (e.g. 25/10/1976)</label><br/>
				<input type="text" name="{$endname}" id="dateTo" value="{$endDateString}" maxlength="10" class="txt"/>
			</div>
		</fieldset>
		<xsl:if test="not($datesearchtype = 'no')">
			<fieldset>
				<input type="radio" name="s_datesearchtype" id="datesearchtype1" value="1" class="radio">
					<xsl:if test="$datesearchtype = 1 or $datesearchtype = 0 or not($datesearchtype) or $datesearchtype=''">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input><xsl:text> </xsl:text>
				<label for="datesearchtype1">Just show memories from within this period</label>

				<input type="radio" name="s_datesearchtype" id="datesearchtype2" value="2" class="radio">
					<xsl:if test="$datesearchtype = 2">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input><xsl:text> </xsl:text>
				<label for="datesearchtype2">Show memories that overlap this period</label>
			</fieldset>
		</xsl:if>
	</xsl:template>

	<!-- output a javascript string variable containing the html for the date field,
	     suitable for e.g. document.write() to insert into the page.
	-->
	<xsl:template name="DATEFIELDS_DATERANGE_JS_STR">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="enddate"/>
		<xsl:param name="endday"/>
		<xsl:param name="endmonth"/>
		<xsl:param name="endyear"/>
		<xsl:param name="datesearchtype"/>
		<xsl:param name="startname">startdate</xsl:param>
		<xsl:param name="endname">enddate</xsl:param>
		<xsl:param name="validationMsg"/>

		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endDateString">
			<xsl:choose>
				<xsl:when test="$enddate and $endday=0">
					<xsl:value-of select="$enddate"/>
				</xsl:when>
				<xsl:when test="$endday and not($endday=0)">
					<xsl:value-of select="$endday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:text>var datefieldsJsHtmlDaterange = '</xsl:text>
		<fieldset>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
			<legend>Date range</legend>
		<xsl:text>'; </xsl:text>
		<xsl:text>var datefieldsJsHtmlDaterange = '</xsl:text>
			<div>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<label for="dateFrom">Date from (e.g. 01/09/1975)</label><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<input type="text" name="{$startname}" id="dateFrom" value="{$startDateString}" maxlength="10" class="txt"/><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
			</div>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
			<div>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<label for="dateTo">Date to (e.g. 25/10/1976)</label><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<input type="text" name="{$endname}" id="dateTo" value="{$endDateString}" maxlength="10" class="txt"/><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
			</div>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
		</fieldset>
		<xsl:text>'; </xsl:text>
		
		<xsl:if test="not($datesearchtype = 'no')">
			<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
			<fieldset>
			<xsl:text>'; </xsl:text>
			<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<input type="radio" name="s_datesearchtype" id="datesearchtype1" value="1" class="radio">
					<xsl:if test="$datesearchtype = 1 or $datesearchtype = 0 or not($datesearchtype) or $datesearchtype=''">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			<xsl:text> '; </xsl:text>
			<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<label for="datesearchtype1" class="radioLabel">Just show memories from within this period</label><br/>
			<xsl:text>'; </xsl:text>
			<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<input type="radio" name="s_datesearchtype" id="datesearchtype2" value="2" class="radio">
					<xsl:if test="$datesearchtype = 2">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			<xsl:text> '; </xsl:text>
			<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
				<label for="datesearchtype2" class="radioLabel">Show memories that overlap this period</label><br/>
			<xsl:text>'; </xsl:text>
			<xsl:text>datefieldsJsHtmlDaterange += '</xsl:text>
			</fieldset>
			<xsl:text>'; </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="DATEFIELDS_FUZZYDATE">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="enddate"/>
		<xsl:param name="endday"/>
		<xsl:param name="endmonth"/>
		<xsl:param name="endyear"/>
		<xsl:param name="timeinterval"/>
		<xsl:param name="validationMsg"/>

		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endDateString">
			<xsl:choose>
				<xsl:when test="$enddate and $endday=0">
					<xsl:value-of select="$enddate"/>
				</xsl:when>
				<xsl:when test="$endday and not($endday=0)">
					<xsl:value-of select="$endday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<fieldset>
			<legend>Approximate date</legend>
			<label for="approxDateFrom">Date from (e.g. 01/09/1975)</label><br/>
			<input type="text" name="startdate" id="approxDateFrom" value="{$startDateString}" maxlength="10" class="txt"/><br/>
			<label for="approxDateTo">Date to (e.g. 25/10/1976)</label><br/>
			<input type="text" name="enddate" id="approxDateTo" value="{$endDateString}" maxlength="10" class="txt"/><br/>

			<label for="approxDuration" class="radiolabel">For a duration of (in days)</label><br/>
			<input type="text" size="2" name="timeinterval" id="approxDuration">
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="$timeinterval and $timeinterval &gt; 0">
							<xsl:value-of select="$timeinterval"/>
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</input><br/>
		</fieldset>
	</xsl:template>

	<xsl:template name="DATEFIELDS_FUZZYDATE_JS_STR">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="enddate"/>
		<xsl:param name="endday"/>
		<xsl:param name="endmonth"/>
		<xsl:param name="endyear"/>
		<xsl:param name="timeinterval"/>
		<xsl:param name="validationMsg"/>

		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endDateString">
			<xsl:choose>
				<xsl:when test="$enddate and $endday=0">
					<xsl:value-of select="$enddate"/>
				</xsl:when>
				<xsl:when test="$endday and not($endday=0)">
					<xsl:value-of select="$endday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:text>var datefieldsJsHtmlFuzzydate = '</xsl:text>
		<fieldset>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<legend>Approximate date</legend>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<label for="approxDateFrom">Date from (e.g. 01/09/1975)</label><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<input type="text" name="startdate" id="approxDateFrom" value="{$startDateString}" maxlength="10" class="txt"/><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<label for="approxDateTo">Date to (e.g. 25/10/1976)</label><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<input type="text" name="enddate" id="approxDateTo" value="{$endDateString}" maxlength="10" class="txt"/><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<label for="approxDuration" class="radiolabel">For a duration of (in days)</label><br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<input type="text" size="2" name="timeinterval" id="approxDuration">
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="$timeinterval and $timeinterval &gt; 0">
							<xsl:value-of select="$timeinterval"/>
						</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</input>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
			<br/>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlFuzzydate += '</xsl:text>
		</fieldset>
		<xsl:text>'; </xsl:text>
	</xsl:template>


	<xsl:template name="DATEFIELDS_NODATE">
		<!-- no date inputs needed needed -->
		<p>
			Your memory will only show in the list view. Please consider using an approximate date range.
		</p>
	</xsl:template>

	<xsl:template name="DATEFIELDS_NODATE_JS_STR">
		<!-- no date inputs needed needed -->
		<xsl:text>var datefieldsJsHtmlNodate = '</xsl:text>
		<p>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlNodate += '</xsl:text>
        <xsl:text>Your memory will only show in the list view. Please consider using an approximate date range.</xsl:text>
		<xsl:text>'; </xsl:text>
		<xsl:text>datefieldsJsHtmlNodate += '</xsl:text>
		</p>
		<xsl:text>'; </xsl:text>
	</xsl:template>

	<xsl:template name="DATEFIELDS_DATE_JS_VARS">
		<xsl:param name="startdate"/>
		<xsl:param name="startday"/>
		<xsl:param name="startmonth"/>
		<xsl:param name="startyear"/>
		<xsl:param name="enddate"/>
		<xsl:param name="endday"/>
		<xsl:param name="endmonth"/>
		<xsl:param name="endyear"/>
		<xsl:param name="timeinterval"/>
		<xsl:param name="validationMsg"/>

		<xsl:variable name="startDateString">
			<xsl:choose>
				<xsl:when test="$startdate and $startday=0">
					<xsl:value-of select="$startdate"/>
				</xsl:when>
				<xsl:when test="$startday and not($startday=0)">
					<xsl:value-of select="$startday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endDateString">
			<xsl:choose>
				<xsl:when test="$enddate and $endday=0">
					<xsl:value-of select="$enddate"/>
				</xsl:when>
				<xsl:when test="$endday and not($endday=0)">
					<xsl:value-of select="$endday"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>var _df_startdate = '</xsl:text>
		<xsl:value-of select="$startDateString"/>
		<xsl:text>';
		</xsl:text>
		<xsl:text>var _df_enddate = '</xsl:text>
		<xsl:value-of select="$endDateString"/>
		<xsl:text>';
		</xsl:text>
		<xsl:text>var _df_timeinterval = '</xsl:text>
		<xsl:value-of select="$timeinterval"/>
		<xsl:text>';
		</xsl:text>
		<xsl:text>var _df_validationMsg = '</xsl:text>
		<xsl:value-of select="$validationMsg"/>
		<xsl:text>';
		</xsl:text>
</xsl:template>
	
	<xsl:template name="PARSE_DATE_DAY">
		<xsl:param name="date"/>
		<xsl:param name="delim">/</xsl:param>
		
		<xsl:value-of select="substring-before($date, $delim)"/>
	</xsl:template>
	
	<xsl:template name="PARSE_DATE_MONTH">
		<xsl:param name="date"/>
		<xsl:param name="delim">/</xsl:param>
		
		<xsl:value-of select="substring-before(substring-after($date, $delim), $delim)"/>
	</xsl:template>
	
	<xsl:template name="PARSE_DATE_YEAR">
		<xsl:param name="date"/>
		<xsl:param name="delim">/</xsl:param>
		
		<xsl:value-of select="substring-after(substring-after($date, $delim), $delim)"/>
	</xsl:template>
	
	<xsl:template name="PARSE_DATE_DECADE">
		<xsl:param name="date"/>
		<xsl:param name="delim">/</xsl:param>
		
		<xsl:variable name="y" select="substring-after(substring-after($date, $delim), $delim)"/>
		
		<xsl:value-of select="$y - ($y mod 10)"/>
	</xsl:template>

	<!-- returns date string in the form yyyymmddhhmmss
		 hhmmss is always 000000
	-->
	<xsl:template name="FORMAT_DATE_FLASH">
		<xsl:param name="date"/>
		<xsl:param name="delim">/</xsl:param>
		
		<xsl:value-of select="format-number(substring-after(substring-after($date, $delim), $delim), '0000')"/>
		<xsl:value-of select="format-number(substring-before(substring-after($date, $delim), $delim), '00')"/>
		<xsl:value-of select="format-number(substring-before($date, $delim), '00')"/>
		<xsl:text>000000</xsl:text>
	</xsl:template>
	
	<xsl:template name="IMPLODE_DATE">
		<xsl:param name="day"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<xsl:param name="delim">/</xsl:param>
		<xsl:param name="intFormat">no</xsl:param>
		<xsl:param name="revFormat">no</xsl:param>

		<xsl:choose>
			<xsl:when test="$intFormat = 'yes'">
				<!-- returns yyyymmdd000000 -->
				<xsl:value-of select="$year"/>
				<xsl:if test="$month &lt; 10 and string-length($month) = 1">
					<xsl:text>0</xsl:text>
				</xsl:if>
				<xsl:value-of select="$month"/>
				<xsl:if test="$day &lt; 10 and string-length($day) = 1">
					<xsl:text>0</xsl:text>
				</xsl:if>
				<xsl:value-of select="$day"/>
				<xsl:text>000000</xsl:text>
			</xsl:when>
			<xsl:when test="$revFormat = 'yes'">
				<!-- returns yyyy/mm/dd -->		
				<xsl:value-of select="$year"/>
				
				<xsl:value-of select="$delim"/>
				
				<xsl:if test="$month &lt; 10 and string-length($month) = 1">
					<xsl:text>0</xsl:text>
				</xsl:if>
				<xsl:value-of select="$month"/>
				
				<xsl:value-of select="$delim"/>
				
				<xsl:if test="$day &lt; 10 and string-length($day) = 1">
					<xsl:text>0</xsl:text>
				</xsl:if>
				<xsl:value-of select="$day"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- returns dd/mm/yyyy -->		
				<xsl:if test="$day &lt; 10 and string-length($day) = 1">
					<xsl:text>0</xsl:text>
				</xsl:if>
				<xsl:value-of select="$day"/>

				<xsl:value-of select="$delim"/>

				<xsl:if test="$month &lt; 10 and string-length($month) = 1">
					<xsl:text>0</xsl:text>
				</xsl:if>
				<xsl:value-of select="$month"/>

				<xsl:value-of select="$delim"/>

				<xsl:value-of select="$year"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="FORMAT_DATE">
		<xsl:param name="date"/>

		<xsl:choose>		
			<xsl:when test="string-length() != 10">
				<xsl:call-template name="IMPLODE_DATE">
					<xsl:with-param name="day">
						<xsl:call-template name="PARSE_DATE_DAY">
							<xsl:with-param name="date" select="$date"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="month">
						<xsl:call-template name="PARSE_DATE_MONTH">
							<xsl:with-param name="date" select="$date"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="year">
						<xsl:call-template name="PARSE_DATE_YEAR">
							<xsl:with-param name="date" select="$date"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GET_DECADE">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_decade']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_decade']/VALUE"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART">
				<xsl:variable name="is_next_day">
					<xsl:call-template name="IS_NEXT_DAY">
						<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
						<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
						<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
						<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
						<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
						<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$is_next_day='yes'">
						<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR - (/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR mod 10)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="CALCULATE_NEAREST_DECADE">
							<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
							<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GET_YEAR">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_year']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_year']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
					<xsl:variable name="is_next_day">
						<xsl:call-template name="IS_NEXT_DAY">
							<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
							<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
							<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
							<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
							<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
							<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$is_next_day='yes'">
							<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR = /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR">
								<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="GET_MONTH">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_month']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_month']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
					<xsl:variable name="is_next_day">
						<xsl:call-template name="IS_NEXT_DAY">
							<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
							<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
							<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
							<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
							<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
							<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$is_next_day='yes'">
							<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR = /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR">
								<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH = /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH">
									<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GET_DAY">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_day']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_day']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART and /H2G2/ARTICLESEARCH/DATERANGEEND">
					<xsl:variable name="date_range_type">
						<xsl:call-template name="GET_DATE_RANGE_TYPE">
							<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
							<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
							<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
							<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
							<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
							<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$date_range_type=1">
						<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GET_DAY_NAME">
		<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAYNAME"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="DAY_SUFFIX">
		<xsl:param name="day"/>
		
		<xsl:choose>
			<xsl:when test="$day = 1 or $day = 21 or $day = 31">st</xsl:when>
			<xsl:when test="$day = 2 or $day = 22">nd</xsl:when>
			<xsl:when test="$day = 3 or $day = 23">rd</xsl:when>
			<xsl:otherwise>th</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="VIEW_NAME">
		<xsl:variable name="decade">
			<xsl:call-template name="GET_DECADE"/>
		</xsl:variable>

		<xsl:variable name="year">
			<xsl:call-template name="GET_YEAR"/>
		</xsl:variable>

		<xsl:variable name="month">
			<xsl:call-template name="GET_MONTH"/>
		</xsl:variable>

		<xsl:variable name="day">
			<xsl:call-template name="GET_DAY"/>
		</xsl:variable>
		
		<xsl:variable name="dayname">
			<xsl:call-template name="GET_DAY_NAME"/>
		</xsl:variable>

		<xsl:variable name="datetype">
			<xsl:call-template name="GET_DATE_RANGE_TYPE">
				<xsl:with-param name="startdate" select="concat(/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY, $date_sep, /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH, $date_sep, /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR)"/>
				<xsl:with-param name="enddate" select="concat(/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY, $date_sep, /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH, $date_sep, /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR)"/>
				<xsl:with-param name="timeinterval" select="/H2G2/ARTICLESEARCH/TIMEINTERVAL"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="startday">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
		</xsl:variable>
		<xsl:variable name="startmonth">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
		</xsl:variable>
		<xsl:variable name="startyear">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
		</xsl:variable>
		<xsl:variable name="endday">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
		</xsl:variable>
		<xsl:variable name="endmonth">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
		</xsl:variable>
		<xsl:variable name="endyear">
			<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
		</xsl:variable>
		
		<xsl:variable name="isLeapYear" select="($startyear mod 4 = 0 and $startyear mod 100 != 0) or $startyear mod 400 = 0"/>
		
		<xsl:variable name="wholeDecade">
			<xsl:choose>
				<xsl:when test="$decade and $decade != 0 and $decade != '' and $decade != 'null' and (($endyear - $startyear) = 9) and $startday = 01 and $startmonth = 01 and $endday = 31 and $endmonth = 12">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="wholeYear">
			<xsl:choose>
				<xsl:when test="$year and $year != 0 and $year != '' and $year != 'null' and $startday = 1 and $startmonth = 01 and $endday = 31 and $endmonth = 12">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="wholeMonth">
			<xsl:choose>
				<xsl:when test="$month and $month != 0 and $month != '' and $month != 'null' and $startday = 1 and (($isLeapYear and $month = 2 and $endday = 29) or $endday = msxsl:node-set($months)/list/item[@m=number($endmonth)]/@days)">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="searchTerms">
			<xsl:call-template name="CHOP">	
				<xsl:with-param name="s">
					<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
						<xsl:if test="not(starts-with(NAME, '_') or NAME='user_memory' or NAME='staff_memory')">
							<xsl:value-of select="NAME"/>
							<xsl:value-of select="$keyword_sep_char_disp"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:with-param>
				<xsl:with-param name="n">2</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="isDateRangeSearch">
			<xsl:choose>
				<xsl:when test="$datetype = 2 and $startday != '' and $endday != '' and /H2G2/PARAMS/PARAM[NAME='s_from']/VALUE='advanced_search' and /H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE = 'Daterange'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="viewNamePreamble">
			<xsl:choose>
				<xsl:when test="$isDateRangeSearch = 'yes'">
					<xsl:text>This search is for memories </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Memories </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$day and $day != 0 and $day != '' and $day != 'null'">
				<xsl:value-of select="$viewNamePreamble"/>
				<xsl:text> of </xsl:text>
				<xsl:if test="$searchTerms != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="$searchTerms"/>
					<xsl:text>&quot;</xsl:text>
					<xsl:text> on </xsl:text>
				</xsl:if>

				<xsl:value-of select="$dayname"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="number($day)"/>
				<xsl:call-template name="DAY_SUFFIX">
					<xsl:with-param name="day" select="$day"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:value-of select="msxsl:node-set($months)/list/item[@m=number($month)]/text()"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:when test="$wholeMonth = 'yes'">
				<xsl:value-of select="$viewNamePreamble"/>
				<xsl:text> of </xsl:text>
				<xsl:if test="$searchTerms != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="$searchTerms"/>
					<xsl:text>&quot;</xsl:text>
					<xsl:text> in </xsl:text>
				</xsl:if>

				<xsl:value-of select="msxsl:node-set($months)/list/item[@m=number($month)]/text()"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:when test="$wholeYear = 'yes'">
				<xsl:value-of select="$viewNamePreamble"/>
				<xsl:text> of </xsl:text>
				<xsl:if test="$searchTerms != ''">
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="$searchTerms"/>
					<xsl:text>&quot;</xsl:text>
					<xsl:text> in </xsl:text>
				</xsl:if>
				
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:when test="$wholeDecade = 'yes'">
				<xsl:value-of select="$viewNamePreamble"/>
				<xsl:text> of </xsl:text>
				<xsl:choose>
					<xsl:when test="$searchTerms != ''">
						<xsl:text>&quot;</xsl:text>
						<xsl:value-of select="$searchTerms"/>
						<xsl:text>&quot;</xsl:text>
						<xsl:text> in the </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> the </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="$decade"/>
				<xsl:text>s</xsl:text>
			</xsl:when>
			<!-- when it's a date range search (but not a whole time period)-->
			<xsl:when test="$datetype = 2 and $startday != '' and $endday != ''">
				<xsl:value-of select="$viewNamePreamble"/>
				<xsl:if test="$searchTerms != ''">
					<xsl:text> of </xsl:text>
					<xsl:text>&quot;</xsl:text>
					<xsl:value-of select="$searchTerms"/>
					<xsl:text>&quot;</xsl:text>
				</xsl:if>
				
				<xsl:text> between </xsl:text>				
				<xsl:call-template name="IMPLODE_DATE">
					<xsl:with-param name="day" select="$startday"/>
					<xsl:with-param name="month" select="$startmonth"/>
					<xsl:with-param name="year" select="$startyear"/>
				</xsl:call-template>
				<xsl:text> and </xsl:text>
				<xsl:call-template name="IMPLODE_DATE">
					<xsl:with-param name="day" select="$endday"/>
					<xsl:with-param name="month" select="$endmonth"/>
					<xsl:with-param name="year" select="$endyear"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$searchTerms != ''">
						<xsl:value-of select="$viewNamePreamble"/>
						<xsl:text> of </xsl:text>
						<xsl:text>&quot;</xsl:text>
						<xsl:value-of select="$searchTerms"/>
						<xsl:text>&quot;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>All memories</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ARTICLE" mode="dcterms_temporal">
		<xsl:if test="DATERANGESTART/DATE/@SORT">
			<xsl:variable name="date_range_type">
				<xsl:call-template name="GET_DATE_RANGE_TYPE">
						<xsl:with-param name="startdate" select="concat(DATERANGESTART/DATE/@DAY, $date_sep, DATERANGESTART/DATE/@MONTH, $date_sep, DATERANGESTART/DATE/@YEAR)"/>
						<xsl:with-param name="enddate" select="concat(DATERANGEEND/DATE/@DAY, $date_sep, DATERANGEEND/DATE/@MONTH, $date_sep, DATERANGEEND/DATE/@YEAR)"/>
						<xsl:with-param name="timeinterval" select="TIMEINTERVAL"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$date_range_type = 1">
					<link rel="schema.dcterms" href="http://purl.org/dc/terms/" /> 
					<meta name="dcterms.temporal" scheme="dcterms.Period">
						<xsl:attribute name="content">
							<xsl:apply-templates select="SUBJECT" mode="dcterms_temporal"/>
							<xsl:text> start=</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@YEAR" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@MONTH" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@DAY" />
							<xsl:text>; </xsl:text>
							<xsl:text> end=</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@YEAR" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@MONTH" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@DAY" />
							<xsl:text>; </xsl:text>
						</xsl:attribute>
					</meta>
				</xsl:when>
				<xsl:when test="$date_range_type = 2">
					<link rel="schema.dcterms" href="http://purl.org/dc/terms/" /> 
					<meta name="dcterms.temporal" scheme="dcterms.Period">
						<xsl:attribute name="content">
							<xsl:apply-templates select="SUBJECT" mode="dcterms_temporal"/>
							<xsl:text> start=</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@YEAR" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@MONTH" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGESTART/DATE/@DAY" />
							<xsl:text>; </xsl:text>
							<xsl:text> end=</xsl:text>
							<xsl:value-of select="DATERANGEEND/DATE/@YEAR" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGEEND/DATE/@MONTH" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="DATERANGEEND/DATE/@DAY" />
							<xsl:text>; </xsl:text>
						</xsl:attribute>
					</meta>
				</xsl:when>
				<!--[FIXME: what to do?]
				<xsl:when test="$date_range_type = 3">
				</xsl:when>
				-->
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- RSS HELPERS -->
	<xsl:template match="SUBJECT" mode="rss_dcterms_temporal">
		<xsl:text>name=</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<xsl:template match="ARTICLE | ARTICLERESULT" mode="rss_dcterms_temporal">
		<xsl:if test="DATERANGESTART/DATE/@SORT">
			<xsl:variable name="date_range_type">
				<xsl:call-template name="GET_DATE_RANGE_TYPE">
						<xsl:with-param name="startdate" select="concat(DATERANGESTART/DATE/@DAY, $date_sep, DATERANGESTART/DATE/@MONTH, $date_sep, DATERANGESTART/DATE/@YEAR)"/>
						<xsl:with-param name="enddate" select="concat(DATERANGEEND/DATE/@DAY, $date_sep, DATERANGEEND/DATE/@MONTH, $date_sep, DATERANGEEND/DATE/@YEAR)"/>
						<xsl:with-param name="timeinterval" select="TIMEINTERVAL"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$date_range_type = 1">
					<xsl:apply-templates select="SUBJECT" mode="rss_dcterms_temporal"/>
					<xsl:text> start=</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@YEAR" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@MONTH" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@DAY" />
					<xsl:text>; </xsl:text>
					<xsl:text> end=</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@YEAR" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@MONTH" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@DAY" />
					<xsl:text>; </xsl:text>
				</xsl:when>
				<xsl:when test="$date_range_type = 2">
					<xsl:apply-templates select="SUBJECT" mode="rss_dcterms_temporal"/>
					<xsl:text> start=</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@YEAR" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@MONTH" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGESTART/DATE/@DAY" />
					<xsl:text>; </xsl:text>
					<xsl:text> end=</xsl:text>
					<xsl:value-of select="DATERANGEEND/DATE/@YEAR" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGEEND/DATE/@MONTH" />
					<xsl:text>-</xsl:text>
					<xsl:value-of select="DATERANGEEND/DATE/@DAY" />
					<xsl:text>; </xsl:text>
				</xsl:when>
				<!--[FIXME: what to do?]
				<xsl:when test="$date_range_type = 3">
				</xsl:when>
				-->
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="EXTRAINFO" mode="rss_dcterms_temporal">
		<xsl:choose>
			<xsl:when test="STARTDATE or (STARTDAY and STARTDAY != 0)">
				<xsl:variable name="startdate" select="STARTDATE"/>
				<xsl:variable name="startday" select="STARTDAY"/>
				<xsl:variable name="startmonth" select="STARTMONTH"/>
				<xsl:variable name="startyear" select="STARTYEAR"/>
				<xsl:variable name="enddate" select="ENDDATE"/>
				<xsl:variable name="endday" select="ENDDAY"/>
				<xsl:variable name="endmonth" select="ENDMONTH"/>
				<xsl:variable name="endyear" select="ENDYEAR"/>
				<xsl:variable name="timeinterval" select="TIMEINTERVAL"/>

				<xsl:variable name="date_range_type">
					<xsl:call-template name="GET_DATE_RANGE_TYPE">
							<xsl:with-param name="startdate" select="$startdate"/>
							<xsl:with-param name="startday" select="$startday"/>
							<xsl:with-param name="startmonth" select="$startmonth"/>
							<xsl:with-param name="startyear" select="$startyear"/>
							<xsl:with-param name="enddate" select="$enddate"/>
							<xsl:with-param name="endday" select="$endday"/>
							<xsl:with-param name="endmonth" select="$endmonth"/>
							<xsl:with-param name="endyear" select="$endyear"/>
							<xsl:with-param name="timeinterval" select="$timeinterval"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="$startday and $startday != 0">
						<xsl:choose>
							<xsl:when test="$date_range_type = 1">
								<xsl:text> start=</xsl:text>
								<xsl:value-of select="$startyear" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startmonth" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startday" />
								<xsl:text>; </xsl:text>
								<xsl:text> end=</xsl:text>
								<xsl:value-of select="$startyear" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startmonth" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startday" />
								<xsl:text>; </xsl:text>
							</xsl:when>
							<xsl:when test="$date_range_type = 2">
								<xsl:text> start=</xsl:text>
								<xsl:value-of select="$startyear" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startmonth" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startday" />
								<xsl:text>; </xsl:text>
								<xsl:text> end=</xsl:text>
								<xsl:value-of select="$endyear" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$endmonth" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$endday" />
								<xsl:text>; </xsl:text>
							</xsl:when>
							<!--[FIXME: what to do?]
							<xsl:when test="$date_range_type = 3">
							</xsl:when>
							-->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="startday_n">
							<xsl:call-template name="PARSE_DATE_DAY">
								<xsl:with-param name="date" select="$startdate"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="startmonth_n">
							<xsl:call-template name="PARSE_DATE_MONTH">
								<xsl:with-param name="date" select="$startdate"/>
							</xsl:call-template>
						</xsl:variable>						
						<xsl:variable name="startyear_n">
							<xsl:call-template name="PARSE_DATE_YEAR">
								<xsl:with-param name="date" select="$startdate"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:variable name="endday_n">
							<xsl:call-template name="PARSE_DATE_DAY">
								<xsl:with-param name="date" select="$enddate"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:variable name="endmonth_n">
							<xsl:call-template name="PARSE_DATE_MONTH">
								<xsl:with-param name="date" select="$enddate"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:variable name="endyear_n">
							<xsl:call-template name="PARSE_DATE_YEAR">
								<xsl:with-param name="date" select="$enddate"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:choose>
							<xsl:when test="$date_range_type = 1">
								<xsl:text> start=</xsl:text>
								<xsl:value-of select="$startyear_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startmonth_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startday_n" />
								<xsl:text>; </xsl:text>
								<xsl:text> end=</xsl:text>
								<xsl:value-of select="$startyear_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startmonth_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startday_n" />
								<xsl:text>; </xsl:text>
							</xsl:when>
							<xsl:when test="$date_range_type = 2">
								<xsl:text> start=</xsl:text>
								<xsl:value-of select="$startyear_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startmonth_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$startday_n" />
								<xsl:text>; </xsl:text>
								<xsl:text> end=</xsl:text>
								<xsl:value-of select="$endyear_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$endmonth_n" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="$endday_n" />
								<xsl:text>; </xsl:text>
							</xsl:when>
							<!--[FIXME: what to do?]
							<xsl:when test="$date_range_type = 3">
							</xsl:when>
							-->
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>'s memory. No date</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- helper templates to output a server-side include statements -->
	<xsl:template name="ssi-include-virtual">
		<xsl:param name="path"/>
		<xsl:comment>#include virtual="<xsl:value-of select="$path"/>"</xsl:comment>
	</xsl:template>
	
	<xsl:template name="ssi-set-var">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:comment>#set var="<xsl:value-of select="$name"/>" value="<xsl:value-of select="$value"/>"</xsl:comment>
	</xsl:template>

	<!-- override from base sso.xsl -->
	<xsl:template name="sso_typedarticle_signin">
		<!-- its a template as their needs to be a param variable for the type, it cannot hold the full, can change text easily as well -->
		<xsl:param name="type"/>
		<xsl:param name="s_datemode"/>
		<xsl:param name="startdate"/>
		<xsl:param name="enddate"/>
		
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="$root"/>
				<xsl:text>TypedArticle?acreate=new</xsl:text>
				<xsl:if test="$type">
					<xsl:text>&amp;type=</xsl:text>
					<xsl:value-of select="$type"/>
				</xsl:if>
				<xsl:if test="$s_datemode">
					<xsl:text>&amp;s_datemode=</xsl:text>
					<xsl:value-of select="$s_datemode"/>
				</xsl:if>
				<xsl:if test="$startdate">
					<xsl:text>&amp;startdate=</xsl:text>
					<xsl:value-of select="$startdate"/>
				</xsl:if>
				<xsl:if test="$enddate">
					<xsl:text>&amp;enddate=</xsl:text>
					<xsl:value-of select="$enddate"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage%26pt=category%26category=', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('%26pt=type%26type=', $type)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<!-- text utils -->
	<xsl:template name="REPLACE_STRING">
		<xsl:param name="s"/>
		<xsl:param name="what"/>
		<xsl:param name="replacement"/>
		<!--
		<code>
			REPLACE_STRING:<br/>
			[<xsl:value-of select="$s"/>]<br/>
			[<xsl:value-of select="$what"/>]<br/>
			[<xsl:value-of select="$replacement"/>]<br/>
		</code>
		-->
		<xsl:if test="$what and string-length($what) != 0">
			<xsl:variable name="ret">
				<xsl:choose>
					<xsl:when test="contains($s, $what)">
						<xsl:value-of select="substring-before($s, $what)"/>
						<xsl:value-of select="$replacement"/>
						<xsl:call-template name="REPLACE_STRING">
							<xsl:with-param name="s" select="substring-after($s, $what)"/>
							<xsl:with-param name="what" select="$what"/>
							<xsl:with-param name="replacement" select="$replacement"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$s"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:value-of select="$ret"/>
		</xsl:if>
	</xsl:template>
	
	
	<!-- 
		splits the input string on $indelim (default = ' ')
		and outputs the keyword tokens as url params (default = 'phrase')
	-->
	<xsl:template name="SPLIT_KEYWORDS_INTO_PARAMS">
		<xsl:param name="s"/>
		<xsl:param name="indelim" select="' '"/>
		<xsl:param name="param">phrase</xsl:param>
		
		<xsl:choose>
			<xsl:when test="string-length($s) &gt; 0 and not(contains($s, $indelim))">
				<xsl:text>&amp;</xsl:text>
				<xsl:value-of select="$param"/>
				<xsl:text>=</xsl:text>
				<xsl:value-of select="$s"/>
			</xsl:when>
			<xsl:when test="string-length(substring-before($s, $indelim)) &gt; 0">
				<xsl:text>&amp;</xsl:text>
				<xsl:value-of select="$param"/>
				<xsl:text>=</xsl:text>
				<xsl:value-of select="substring-before($s, $indelim)"/>
				
				<xsl:call-template name="SPLIT_KEYWORDS_INTO_PARAMS">
					<xsl:with-param name="s" select="substring-after($s, $indelim)"/>
					<xsl:with-param name="indelim" select="$indelim"/>
					<xsl:with-param name="param" select="$param"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!--
		splits the input string on $indelim (default = ' ') 
		and ouputs the keywords joined by $outdelim (default = ' ')
		ignores keywords starting with $prefix (default = $keyword_prefix_prelim)
	-->
	<xsl:template name="SPLIT_KEYWORDS">
		<xsl:param name="s"/>
		<xsl:param name="indelim" select="' '"/>
		<xsl:param name="outdelim" select="' '"/>
		<xsl:param name="prefix" select="$keyword_prefix_prelim"/>
		
		<xsl:choose>
			<xsl:when test="string-length($s) &gt; 0 and not(contains($s, $indelim))">
				<xsl:if test="not(starts-with($s, $prefix))">
					<xsl:value-of select="$s"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="string-length(substring-before($s, $indelim)) &gt; 0">
				<xsl:if test="not(starts-with(substring-before($s, $indelim), $prefix))">
					<xsl:value-of select="substring-before($s, $indelim)"/>
					<xsl:value-of select="$outdelim"/>
				</xsl:if>
				<xsl:call-template name="SPLIT_KEYWORDS">
					<xsl:with-param name="s" select="substring-after($s, $indelim)"/>
					<xsl:with-param name="indelim" select="$indelim"/>
					<xsl:with-param name="outdelim" select="$outdelim"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
		
	<!--
		splits the input string on $indelim (default = $keyword_sep_char) 
		and ouputs the keywords as links to articlesearch joined by $outdelim (defaul = ' ')
		ignores keywords starting with $prefex (default = $keyword_prefix_prelim)
	-->
	<xsl:template name="SPLIT_KEYWORDS_INTO_LINKS">
		<xsl:param name="s"/>
		<xsl:param name="indelim" select="$keyword_sep_char"/>
		<xsl:param name="outdelim" select="' '"/>
		<xsl:param name="prefix" select="$keyword_prefix_prelim"/>
		
		<xsl:choose>
			<xsl:when test="string-length($s) &gt; 0 and not(contains($s, $indelim))">
				<xsl:if test="not(starts-with($s, $prefix))">
					<xsl:variable name="phrase_escaped">
						<xsl:call-template name="URL_ESCAPE">
							<xsl:with-param name="s" select="$s"/>
						</xsl:call-template>
					</xsl:variable>

					<a href="{$articlesearchroot}&amp;phrase={$phrase_escaped}">
						<xsl:value-of select="$s"/>
					</a>
				</xsl:if>
			</xsl:when>
			<xsl:when test="string-length(substring-before($s, $indelim)) &gt; 0">
				<xsl:if test="not(starts-with(substring-before($s, $indelim), $prefix))">
					<xsl:variable name="phrase_escaped">
						<xsl:call-template name="URL_ESCAPE">
							<xsl:with-param name="s" select="substring-before($s, $indelim)"/>
						</xsl:call-template>
					</xsl:variable>

					<a href="{$articlesearchroot}&amp;phrase={$phrase_escaped}">
						<xsl:value-of select="substring-before($s, $indelim)"/>
					</a>
					<xsl:value-of select="$outdelim"/>
				</xsl:if>
				<xsl:call-template name="SPLIT_KEYWORDS_INTO_LINKS">
					<xsl:with-param name="s" select="substring-after($s, $indelim)"/>
					<xsl:with-param name="indelim" select="$indelim"/>
					<xsl:with-param name="outdelim" select="$outdelim"/>
					<xsl:with-param name="prefix" select="$prefix"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- trims off the last n character(s) from the end of a string (default = 1) -->
	<xsl:template name="CHOP">
		<xsl:param name="s"/>
		<xsl:param name="n">1</xsl:param>
		<xsl:value-of select="substring($s, 1, string-length($s)-$n)"/>
	</xsl:template>

	<!-- trims spaces from the end of a string -->	
	<xsl:template name="CHOMP">
		<xsl:param name="s"/>
		<xsl:value-of select="substring-before($s, ' ')"/>		
	</xsl:template>
	
	<!-- trims spaces from both ends of a string -->
	<xsl:template name="TRIM">
		<xsl:param name="s"/>
		<xsl:value-of select="substring-after(substring-before($s, ' '), ' ')"/>
	</xsl:template>
	
	<!-- 
		splits a string on the given delimeter character (default ' ')
		and returns a node set of the form:
		<tokens>
			<token>token_literal1</token>
			<token>token_literal2</token>
			...
			<token>token_literaln</token>
		</tokens>
		
		[FIXME: currently doesn't output a node set]
	-->
	<xsl:template name="TOKENIZE_STRING">
		<xsl:param name="s"/>
		<xsl:param name="delim"><xsl:text> </xsl:text></xsl:param>
		
		<xsl:variable name="ret">
			<tokens>
				<xsl:call-template name="TOKENIZE_STRING_EXEC">
					<xsl:with-param name="s" select="$s"/>
					<xsl:with-param name="delim" select="$delim"/>
				</xsl:call-template>
			</tokens>
		</xsl:variable>
		
		<xsl:value-of select="msxsl:node-set($ret)"/>
	</xsl:template>
	
	<xsl:template name="TOKENIZE_STRING_EXEC">
		<xsl:param name="s"/>
		<xsl:param name="delim"/>
		
		<xsl:choose>
			<xsl:when test="string-length($s) &gt; 0 and not(contains($s, $delim))">
				<token><xsl:value-of select="$s"/></token>
			</xsl:when>
			<xsl:when test="string-length(substring-before($s, $delim)) &gt; 0">
				<token><xsl:value-of select="substring-before($s, $delim)"/></token>
				<xsl:call-template name="TOKENIZE_STRING_EXEC">
					<xsl:with-param name="s" select="substring-after($s, $delim)"/>
					<xsl:with-param name="delim" select="$delim"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="URL_ESCAPE">
		<xsl:param name="s"/>
		<!--
		<code>
			REPLACE_STRING:<br/>
			[<xsl:value-of select="$s"/>]<br/>
		</code>
		-->
		<xsl:if test="$s and string-length($s) != 0">
			<xsl:call-template name="URL_ESCAPE_EXEC">
				<xsl:with-param name="c" select="substring($s, 1, 1)"/> 
			</xsl:call-template>
			<xsl:call-template name="URL_ESCAPE">
				<xsl:with-param name="s" select="substring($s, 2)"/> 
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="URL_ESCAPE_EXEC">
		<xsl:param name="c"/>

		<!-- escape illegal characters, otherwise echo back the character -->		
		<xsl:choose>
			<xsl:when test="$c='%'">%25</xsl:when>
			<xsl:when test="$c='#'">%23</xsl:when>
			<xsl:when test="$c='?'">%3F</xsl:when>
			<xsl:when test="$c='/'">%2F</xsl:when>
			<xsl:when test="$c='='">%3D</xsl:when>
			<xsl:when test="$c='&amp;'">%26</xsl:when>
			<xsl:when test="$c=' '">%20</xsl:when>
			<xsl:otherwise><xsl:value-of select="$c"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- links to add article to popular social bookmarking/aggregation sites -->
	<xsl:template name="SOCIAL_LINKS">
		<xsl:param name="url"/>
		<xsl:param name="title"/>
		
		<xsl:variable name="esc_url">
			<xsl:call-template name="URL_ESCAPE">
				<xsl:with-param name="s" select="$url"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="esc_title">
			<xsl:call-template name="URL_ESCAPE">
				<xsl:with-param name="s" select="$title"/>
			</xsl:call-template>
		</xsl:variable>
		
		<div id="socialBookMarks" class="sharesb"> 
			<h4>Bookmark with:</h4> 
			<ul>
				<li class="delicious"> 
					<a id="delicious" title="Post this story to Delicious" href="http://del.icio.us/post?url={$esc_url}&amp;title={$esc_title}">Delicious</a> 
				</li>
				<li class="digg"> 
					<a id="digg" title="Post this story to Digg" href="http://digg.com/submit?url={$esc_url}&amp;title={$esc_title}">Digg</a> 
				</li>
				<li class="reddit"> 
					<a id="reddit" title="Post this story to reddit" href="http://reddit.com/submit?url={$esc_url}&amp;title={$esc_title}">reddit</a> 
				</li>
				<li class="facebook"> 
					<a id="facebook" title="Post this story to Facebook" href="http://www.facebook.com/sharer.php?u={$esc_url}&amp;t={$esc_title}">Facebook</a> 
				</li>
				<li class="stumbleupon"> 
					<a id="stumbleupon" title="Post this story to StumbleUpon" href="http://www.stumbleupon.com/submit?url={$esc_url}&amp;title={$esc_title}">StumbleUpon</a> 
				</li>
			</ul>
			<p><a href="http://news.bbc.co.uk/1/hi/help/6915817.stm">What are these?</a></p>
		</div>
	</xsl:template>
	
	<!-- serialize xml to json
		[TODO: experimental]
	-->
	<xsl:template match="node()" mode="xml2Json">
	</xsl:template>
	
	<!-- location radio inputs
		 [TODO: ideally this should be converted into some kind of lookup table and generated]
	-->
	<xsl:template name="GENERATE_COMBINED_LOCATION_RADIOS_NON_FLASH_CONTENT">
		<xsl:param name="selectedValue"/>
		<xsl:param name="fieldName">location</xsl:param>
		
		<div id="noFlashContent">
			<fieldset id="locationList">
				<fieldset id="england">
					<legend>England</legend>
					<div class="col1">
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="bedsHeartsBucks" value="_location-Beds Herts and Bucks{$keyword_sep_char}Beds Herts and Bucks{$keyword_sep_char}_location-Bedfordshire Hertfordshire and Buckinghamshire{$keyword_sep_char}Bedfordshire Hertfordshire and Buckinghamshire{$keyword_sep_char}_location-Bedfordshire{$keyword_sep_char}Bedfordshire{$keyword_sep_char}_location-Hertfordshire{$keyword_sep_char}Hertfordshire{$keyword_sep_char}_location-Buckinghamshire{$keyword_sep_char}Buckinghamshire{$keyword_sep_char}_location-Beds{$keyword_sep_char}Beds{$keyword_sep_char}_location-Herts{$keyword_sep_char}Herts{$keyword_sep_char}_location-Bucks{$keyword_sep_char}Bucks"><xsl:if test="$selectedValue=concat('_location-Beds Herts and Bucks',$keyword_sep_char,'Beds Herts and Bucks',$keyword_sep_char,'_location-Bedfordshire Hertfordshire and Buckinghamshire',$keyword_sep_char,'Bedfordshire Hertfordshire and Buckinghamshire',$keyword_sep_char,'_location-Bedfordshire',$keyword_sep_char,'Bedfordshire',$keyword_sep_char,'_location-Hertfordshire',$keyword_sep_char,'Hertfordshire',$keyword_sep_char,'_location-Buckinghamshire',$keyword_sep_char,'Buckinghamshire',$keyword_sep_char,'_location-Beds',$keyword_sep_char,'Beds',$keyword_sep_char,'_location-Herts',$keyword_sep_char,'Herts',$keyword_sep_char,'_location-Bucks',$keyword_sep_char,'Bucks') or $selectedValue=concat('_location-Beds',$keyword_sep_char,'Beds',$keyword_sep_char,'_location-Herts',$keyword_sep_char,'Herts',$keyword_sep_char,'_location-Bucks',$keyword_sep_char,'Bucks') or $selectedValue='_location-Beds Beds _location-Herts Herts _location-Bucks Bucks'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="bedsHeartsBucks">Beds Herts and Bucks</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="berkshire" value="_location-Berkshire{$keyword_sep_char}Berkshire{$keyword_sep_char}_location-Berks{$keyword_sep_char}Berks"><xsl:if test="$selectedValue=concat('_location-Berkshire',$keyword_sep_char,'Berkshire',$keyword_sep_char,'_location-Berks',$keyword_sep_char,'Berks') or $selectedValue=concat('_location-Berkshire',$keyword_sep_char,'Berkshire') or $selectedValue='_location-Berkshire Berkshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="berkshire">Berkshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="birmingham" value="_location-Birmingham{$keyword_sep_char}Birmingham"><xsl:if test="$selectedValue=concat('_location-Birmingham',$keyword_sep_char,'Birmingham') or $selectedValue=concat('_location-Birmingham',$keyword_sep_char,'Birmingham') or $selectedValue='_location-Birmingham Birmingham'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="birmingham">Birmingham</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="blackCountry" value="_location-Black Country{$keyword_sep_char}Black Country"><xsl:if test="$selectedValue=concat('_location-Black Country',$keyword_sep_char,'Black Country') or $selectedValue=concat('_location-Black',$keyword_sep_char,'Black',$keyword_sep_char,'_location-Country',$keyword_sep_char,'Country') or $selectedValue='_location-Black Black _location-Country Country'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="blackCountry">Black Country</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="bradfordWestYorks" value="_location-Bradford and W Yorks{$keyword_sep_char}Bradford and W Yorks{$keyword_sep_char}_location-Bradford and West Yorkshire{$keyword_sep_char}Bradford and West Yorkshire{$keyword_sep_char}_location-Bradford{$keyword_sep_char}Bradford{$keyword_sep_char}_location-Yorkshire{$keyword_sep_char}Yorkshire{$keyword_sep_char}_location-West Yorkshire{$keyword_sep_char}West Yorkshire{$keyword_sep_char}_location-Bradford and West Yorkshire{$keyword_sep_char}Bradford and West Yorkshire"><xsl:if test="$selectedValue=concat('_location-Bradford and W Yorks',$keyword_sep_char,'Bradford and W Yorks',$keyword_sep_char,'_location-Bradford and West Yorkshire',$keyword_sep_char,'Bradford and West Yorkshire',$keyword_sep_char,'_location-Bradford',$keyword_sep_char,'Bradford',$keyword_sep_char,'_location-Yorkshire',$keyword_sep_char,'Yorkshire',$keyword_sep_char,'_location-West Yorkshire',$keyword_sep_char,'West Yorkshire',$keyword_sep_char,'_location-Bradford and West Yorkshire',$keyword_sep_char,'Bradford and West Yorkshire') or $selectedValue=concat('_location-Bradford',$keyword_sep_char,'Bradford',$keyword_sep_char,'_location-W',$keyword_sep_char,'W',$keyword_sep_char,'_location-Yorks',$keyword_sep_char,'Yorks') or $selectedValue='_location-Bradford Bradford _location-W W _location-Yorks Yorks'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="bradfordWestYorks">Bradford and W Yorks</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="bristol" value="_location-Bristol{$keyword_sep_char}Bristol"><xsl:if test="$selectedValue=concat('_location-Bristol',$keyword_sep_char,'Bristol') or $selectedValue=concat('_location-Bristol',$keyword_sep_char,'Bristol') or $selectedValue='_location-Bristol Bristol'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="bristol">Bristol</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="cambridgeshire" value="_location-Cambridgeshire{$keyword_sep_char}Cambridgeshire{$keyword_sep_char}_location-Cambs{$keyword_sep_char}Cambs{$keyword_sep_char}_location-Cambridge{$keyword_sep_char}Cambridge"><xsl:if test="$selectedValue=concat('_location-Cambridgeshire',$keyword_sep_char,'Cambridgeshire',$keyword_sep_char,'_location-Cambs',$keyword_sep_char,'Cambs',$keyword_sep_char,'_location-Cambridge',$keyword_sep_char,'Cambridge') or $selectedValue=concat('_location-Cambridgeshire',$keyword_sep_char,'Cambridgeshire') or $selectedValue='_location-Cambridgeshire Cambridgeshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="cambridgeshire">Cambridgeshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="cornwall" value="_location-Cornwall{$keyword_sep_char}Cornwall"><xsl:if test="$selectedValue=concat('_location-Cornwall',$keyword_sep_char,'Cornwall') or $selectedValue=concat('_location-Cornwall',$keyword_sep_char,'Cornwall') or $selectedValue='_location-Cornwall Cornwall'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="cornwall">Cornwall</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="coventryWarks" value="_location-Coventry and Warks{$keyword_sep_char}Coventry and Warks{$keyword_sep_char}_location-Warwickshire{$keyword_sep_char}Warwickshire{$keyword_sep_char}_location-Coventry{$keyword_sep_char}Coventry{$keyword_sep_char}_location-Coventry and Warwickshire{$keyword_sep_char}Coventry and Warwickshire{$keyword_sep_char}_location-Coventry and Warks{$keyword_sep_char}Coventry and Warks"><xsl:if test="$selectedValue=concat('_location-Coventry and Warks',$keyword_sep_char,'Coventry and Warks',$keyword_sep_char,'_location-Warwickshire',$keyword_sep_char,'Warwickshire',$keyword_sep_char,'_location-Coventry',$keyword_sep_char,'Coventry',$keyword_sep_char,'_location-Coventry and Warwickshire',$keyword_sep_char,'Coventry and Warwickshire',$keyword_sep_char,'_location-Coventry and Warks',$keyword_sep_char,'Coventry and Warks') or $selectedValue=concat('_location-Coventry',$keyword_sep_char,'Coventry',$keyword_sep_char,'_location-Warks',$keyword_sep_char,'Warks') or $selectedValue='_location-Coventry Coventry _location-Warks Warks'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="coventryWarks">Coventry and Warks</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="cumbria" value="_location-Cumbria{$keyword_sep_char}Cumbria"><xsl:if test="$selectedValue=concat('_location-Cumbria',$keyword_sep_char,'Cumbria') or $selectedValue=concat('_location-Cumbria',$keyword_sep_char,'Cumbria') or $selectedValue='_location-Cumbria Cumbria'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="cumbria">Cumbria</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="derby" value="_location-Derby{$keyword_sep_char}Derby{$keyword_sep_char}_location-Derbyshire{$keyword_sep_char}Derbyshire"><xsl:if test="$selectedValue=concat('_location-Derby',$keyword_sep_char,'Derby',$keyword_sep_char,'_location-Derbyshire',$keyword_sep_char,'Derbyshire') or $selectedValue=concat('_location-Derby',$keyword_sep_char,'Derby') or $selectedValue='_location-Derby Derby'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="derby">Derby</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="devon" value="_location-Devon{$keyword_sep_char}Devon"><xsl:if test="$selectedValue=concat('_location-Devon',$keyword_sep_char,'Devon') or $selectedValue=concat('_location-Devon',$keyword_sep_char,'Devon') or $selectedValue='_location-Devon Devon'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="devon">Devon</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="dorset" value="_location-Dorset{$keyword_sep_char}Dorset"><xsl:if test="$selectedValue=concat('_location-Dorset',$keyword_sep_char,'Dorset') or $selectedValue=concat('_location-Dorset',$keyword_sep_char,'Dorset') or $selectedValue='_location-Dorset Dorset'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="dorset">Dorset</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="essex" value="_location-Essex{$keyword_sep_char}Essex"><xsl:if test="$selectedValue=concat('_location-Essex',$keyword_sep_char,'Essex') or $selectedValue=concat('_location-Essex',$keyword_sep_char,'Essex') or $selectedValue='_location-Essex Essex'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="essex">Essex</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="gloucestershire" value="_location-Gloucestershire{$keyword_sep_char}Gloucestershire{$keyword_sep_char}_location-Gloucester{$keyword_sep_char}Gloucester"><xsl:if test="$selectedValue=concat('_location-Gloucestershire',$keyword_sep_char,'Gloucestershire',$keyword_sep_char,'_location-Gloucester',$keyword_sep_char,'Gloucester') or $selectedValue=concat('_location-Gloucestershire',$keyword_sep_char,'Gloucestershire') or $selectedValue='_location-Gloucestershire Gloucestershire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="gloucestershire">Gloucestershire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="hampshire" value="_location-Hampshire{$keyword_sep_char}Hampshire{$keyword_sep_char}_location-Hants{$keyword_sep_char}Hants"><xsl:if test="$selectedValue=concat('_location-Hampshire',$keyword_sep_char,'Hampshire',$keyword_sep_char,'_location-Hants',$keyword_sep_char,'Hants') or $selectedValue=concat('_location-Hampshire',$keyword_sep_char,'Hampshire') or $selectedValue='_location-Hampshire Hampshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="hampshire">Hampshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="herefordWorcs" value="_location-Hereford and Worcs{$keyword_sep_char}Hereford and Worcs{$keyword_sep_char}_location-Hereford{$keyword_sep_char}Hereford{$keyword_sep_char}_location-Hereford and Worcs{$keyword_sep_char}Hereford and Worcs{$keyword_sep_char}_location-Hereford and Worcestershire{$keyword_sep_char}Hereford and Worcestershire{$keyword_sep_char}_location-Worcestershire{$keyword_sep_char}Worcestershire{$keyword_sep_char}_location-Worcs{$keyword_sep_char}Worcs"><xsl:if test="$selectedValue=concat('_location-Hereford and Worcs',$keyword_sep_char,'Hereford and Worcs',$keyword_sep_char,'_location-Hereford',$keyword_sep_char,'Hereford',$keyword_sep_char,'_location-Hereford and Worcs',$keyword_sep_char,'Hereford and Worcs',$keyword_sep_char,'_location-Hereford and Worcestershire',$keyword_sep_char,'Hereford and Worcestershire',$keyword_sep_char,'_location-Worcestershire',$keyword_sep_char,'Worcestershire',$keyword_sep_char,'_location-Worcs',$keyword_sep_char,'Worcs') or $selectedValue=concat('_location-Hereford',$keyword_sep_char,'Hereford',$keyword_sep_char,'_location-Worcs',$keyword_sep_char,'Worcs') or $selectedValue='_location-Hereford Hereford _location-Worcs Worcs'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="herefordWorcs">Hereford and Worcs</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="humber" value="_location-Humber{$keyword_sep_char}Humber"><xsl:if test="$selectedValue=concat('_location-Humber',$keyword_sep_char,'Humber') or $selectedValue=concat('_location-Humber',$keyword_sep_char,'Humber') or $selectedValue='_location-Humber Humber'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="humber">Humber</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="kent" value="_location-Kent{$keyword_sep_char}Kent"><xsl:if test="$selectedValue=concat('_location-Kent',$keyword_sep_char,'Kent') or $selectedValue=concat('_location-Kent',$keyword_sep_char,'Kent') or $selectedValue='_location-Kent Kent'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="kent">Kent</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="lancashire" value="_location-Lancashire{$keyword_sep_char}Lancashire{$keyword_sep_char}_location-Lancs{$keyword_sep_char}Lancs"><xsl:if test="$selectedValue=concat('_location-Lancashire',$keyword_sep_char,'Lancashire',$keyword_sep_char,'_location-Lancs',$keyword_sep_char,'Lancs') or $selectedValue=concat('_location-Lancashire',$keyword_sep_char,'Lancashire') or $selectedValue='_location-Lancashire Lancashire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="lancashire">Lancashire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="leeds" value="_location-Leeds{$keyword_sep_char}Leeds"><xsl:if test="$selectedValue=concat('_location-Leeds',$keyword_sep_char,'Leeds') or $selectedValue=concat('_location-Leeds',$keyword_sep_char,'Leeds') or $selectedValue='_location-Leeds Leeds'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="leeds">Leeds</label></div>
					</div>
					<div class="col2">	
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="leicester" value="_location-Leicester{$keyword_sep_char}Leicester{$keyword_sep_char}_location-Leics{$keyword_sep_char}Leics"><xsl:if test="$selectedValue=concat('_location-Leicester',$keyword_sep_char,'Leicester',$keyword_sep_char,'_location-Leics',$keyword_sep_char,'Leics') or $selectedValue=concat('_location-Leicester',$keyword_sep_char,'Leicester') or $selectedValue='_location-Leicester Leicester'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="leicester">Leicester</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="lincolnshire" value="_location-Lincolnshire{$keyword_sep_char}Lincolnshire{$keyword_sep_char}_location-Lincs{$keyword_sep_char}Lincs{$keyword_sep_char}_location-Lincoln{$keyword_sep_char}Lincoln"><xsl:if test="$selectedValue=concat('_location-Lincolnshire',$keyword_sep_char,'Lincolnshire',$keyword_sep_char,'_location-Lincs',$keyword_sep_char,'Lincs',$keyword_sep_char,'_location-Lincoln',$keyword_sep_char,'Lincoln') or $selectedValue=concat('_location-Lincolnshire',$keyword_sep_char,'Lincolnshire') or $selectedValue='_location-Lincolnshire Lincolnshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="lincolnshire">Lincolnshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="liverpool" value="_location-Liverpool{$keyword_sep_char}Liverpool{$keyword_sep_char}_location-Merseyside{$keyword_sep_char}Merseyside"><xsl:if test="$selectedValue=concat('_location-Liverpool',$keyword_sep_char,'Liverpool',$keyword_sep_char,'_location-Merseyside',$keyword_sep_char,'Merseyside') or $selectedValue=concat('_location-Liverpool',$keyword_sep_char,'Liverpool') or $selectedValue='_location-Liverpool Liverpool'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="liverpool">Liverpool</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="london" value="_location-London{$keyword_sep_char}London"><xsl:if test="$selectedValue=concat('_location-London',$keyword_sep_char,'London') or $selectedValue=concat('_location-London',$keyword_sep_char,'London') or $selectedValue='_location-London London'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="london">London</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="manchester" value="_location-Manchester{$keyword_sep_char}Manchester{$keyword_sep_char}_location-Man{$keyword_sep_char}Man"><xsl:if test="$selectedValue=concat('_location-Manchester',$keyword_sep_char,'Manchester',$keyword_sep_char,'_location-Man',$keyword_sep_char,'Man') or $selectedValue=concat('_location-Manchester',$keyword_sep_char,'Manchester') or $selectedValue='_location-Manchester Manchester'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="manchester">Manchester</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="norfolk" value="_location-Norfolk{$keyword_sep_char}Norfolk"><xsl:if test="$selectedValue=concat('_location-Norfolk',$keyword_sep_char,'Norfolk') or $selectedValue=concat('_location-Norfolk',$keyword_sep_char,'Norfolk') or $selectedValue='_location-Norfolk Norfolk'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="norfolk">Norfolk</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="northamptonshire" value="_location-Northamptonshire{$keyword_sep_char}Northamptonshire"><xsl:if test="$selectedValue=concat('_location-Northamptonshire',$keyword_sep_char,'Northamptonshire') or $selectedValue=concat('_location-Northamptonshire',$keyword_sep_char,'Northamptonshire') or $selectedValue='_location-Northamptonshire Northamptonshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="northamptonshire">Northamptonshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="northYorkshire" value="_location-North Yorkshire{$keyword_sep_char}North Yorkshire{$keyword_sep_char}_location-North Yorks{$keyword_sep_char}North Yorks{$keyword_sep_char}_location-Yorks{$keyword_sep_char}Yorks{$keyword_sep_char}_location-Yorkshire{$keyword_sep_char}Yorkshire"><xsl:if test="$selectedValue=concat('_location-North Yorkshire',$keyword_sep_char,'North Yorkshire',$keyword_sep_char,'_location-North Yorks',$keyword_sep_char,'North Yorks',$keyword_sep_char,'_location-Yorks',$keyword_sep_char,'Yorks',$keyword_sep_char,'_location-Yorkshire',$keyword_sep_char,'Yorkshire') or $selectedValue=concat('_location-North',$keyword_sep_char,'North',$keyword_sep_char,'_location-Yorkshire',$keyword_sep_char,'Yorkshire') or $selectedValue='_location-North North _location-Yorkshire Yorkshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="northYorkshire">North Yorkshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="nottingham" value="_location-Nottingham{$keyword_sep_char}Nottingham{$keyword_sep_char}_location-Notts{$keyword_sep_char}Notts"><xsl:if test="$selectedValue=concat('_location-Nottingham',$keyword_sep_char,'Nottingham',$keyword_sep_char,'_location-Notts',$keyword_sep_char,'Notts') or $selectedValue=concat('_location-Nottingham',$keyword_sep_char,'Nottingham') or $selectedValue='_location-Nottingham Nottingham'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="nottingham">Nottingham</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="oxford" value="_location-Oxford{$keyword_sep_char}Oxford"><xsl:if test="$selectedValue=concat('_location-Oxford',$keyword_sep_char,'Oxford') or $selectedValue=concat('_location-Oxford',$keyword_sep_char,'Oxford') or $selectedValue='_location-Oxford Oxford'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="oxford">Oxford</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="shropshire" value="_location-Shropshire{$keyword_sep_char}Shropshire{$keyword_sep_char}_location-Shrops{$keyword_sep_char}Shrops"><xsl:if test="$selectedValue=concat('_location-Shropshire',$keyword_sep_char,'Shropshire',$keyword_sep_char,'_location-Shrops',$keyword_sep_char,'Shrops') or $selectedValue=concat('_location-Shropshire',$keyword_sep_char,'Shropshire') or $selectedValue='_location-Shropshire Shropshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="shropshire">Shropshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="somerset" value="_location-Somerset{$keyword_sep_char}Somerset"><xsl:if test="$selectedValue=concat('_location-Somerset',$keyword_sep_char,'Somerset') or $selectedValue=concat('_location-Somerset',$keyword_sep_char,'Somerset') or $selectedValue='_location-Somerset Somerset'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="somerset">Somerset</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="southYorkshire" value="_location-South Yorkshire{$keyword_sep_char}South Yorkshire{$keyword_sep_char}_location-Yorks{$keyword_sep_char}Yorks{$keyword_sep_char}_location-Yorkshire{$keyword_sep_char}Yorkshire"><xsl:if test="$selectedValue=concat('_location-South Yorkshire',$keyword_sep_char,'South Yorkshire',$keyword_sep_char,'_location-Yorks',$keyword_sep_char,'Yorks',$keyword_sep_char,'_location-Yorkshire',$keyword_sep_char,'Yorkshire') or $selectedValue=concat('_location-South',$keyword_sep_char,'South',$keyword_sep_char,'_location-Yorkshire',$keyword_sep_char,'Yorkshire') or $selectedValue='_location-South South _location-Yorkshire Yorkshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="southYorkshire">South Yorkshire</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="southernCounties" value="_location-Southern Counties{$keyword_sep_char}Southern Counties"><xsl:if test="$selectedValue=concat('_location-Southern Counties',$keyword_sep_char,'Southern Counties') or $selectedValue=concat('_location-Southern',$keyword_sep_char,'_location-Counties',$keyword_sep_char,'Southern',$keyword_sep_char,'Counties') or $selectedValue='_location-Southern _location-Counties Southern Counties'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="southernCounties">Southern Counties</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="stokeStaffs" value="_location-Stoke and Staffs{$keyword_sep_char}Stoke and Staffs{$keyword_sep_char}_location-Stoke and Staffordshire{$keyword_sep_char}Stoke and Staffordshire{$keyword_sep_char}_location-Stoke{$keyword_sep_char}Stoke{$keyword_sep_char}_location-Staffordshire{$keyword_sep_char}Staffordshire"><xsl:if test="$selectedValue=concat('_location-Stoke and Staffs',$keyword_sep_char,'Stoke and Staffs',$keyword_sep_char,'_location-Stoke and Staffordshire',$keyword_sep_char,'Stoke and Staffordshire',$keyword_sep_char,'_location-Stoke',$keyword_sep_char,'Stoke',$keyword_sep_char,'_location-Staffordshire',$keyword_sep_char,'Staffordshire') or $selectedValue=concat('_location-Stoke',$keyword_sep_char,'Stoke',$keyword_sep_char,'_location-Staffs',$keyword_sep_char,'Staffs') or $selectedValue='_location-Stoke Stoke _location-Staffs Staffs'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="stokeStaffs">Stoke and Staffs</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="suffolk" value="_location-Suffolk{$keyword_sep_char}Suffolk"><xsl:if test="$selectedValue=concat('_location-Suffolk',$keyword_sep_char,'Suffolk') or $selectedValue=concat('_location-Suffolk',$keyword_sep_char,'Suffolk') or $selectedValue='_location-Suffolk Suffolk'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="suffolk">Suffolk</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="surreySussex" value="_location-Surrey and Sussex{$keyword_sep_char}Surrey and Sussex{$keyword_sep_char}_location-Surrey{$keyword_sep_char}Surrey{$keyword_sep_char}_location-Sussex{$keyword_sep_char}Sussex{$keyword_sep_char}_location-Surrey and Sussex{$keyword_sep_char}Surrey and Sussex"><xsl:if test="$selectedValue=concat('_location-Surrey and Sussex',$keyword_sep_char,'Surrey and Sussex',$keyword_sep_char,'_location-Surrey',$keyword_sep_char,'Surrey',$keyword_sep_char,'_location-Sussex',$keyword_sep_char,'Sussex',$keyword_sep_char,'_location-Surrey and Sussex',$keyword_sep_char,'Surrey and Sussex') or $selectedValue=concat('_location-Surrey',$keyword_sep_char,'Surrey',$keyword_sep_char,'_location-Sussex',$keyword_sep_char,'Sussex') or $selectedValue='_location-Surrey Surrey _location-Sussex Sussex'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="surreySussex">Surrey and Sussex</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="tees" value="_location-Tees{$keyword_sep_char}Tees"><xsl:if test="$selectedValue=concat('_location-Tees',$keyword_sep_char,'Tees') or $selectedValue=concat('_location-Tees',$keyword_sep_char,'Tees') or $selectedValue='_location-Tees Tees'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="tees">Tees</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="tyne" value="_location-Tyne{$keyword_sep_char}Tyne"><xsl:if test="$selectedValue=concat('_location-Tyne',$keyword_sep_char,'Tyne') or $selectedValue=concat('_location-Tyne',$keyword_sep_char,'Tyne') or $selectedValue='_location-Tyne Tyne'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="tyne">Tyne</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="wear" value="_location-Wear{$keyword_sep_char}Wear"><xsl:if test="$selectedValue=concat('_location-Wear',$keyword_sep_char,'Wear') or $selectedValue=concat('_location-Wear',$keyword_sep_char,'Wear') or $selectedValue='_location-Wear Wear'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="wear">Wear</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="wiltshire" value="_location-Wiltshire{$keyword_sep_char}Wiltshire"><xsl:if test="$selectedValue=concat('_location-Wiltshire',$keyword_sep_char,'Wiltshire') or $selectedValue=concat('_location-Wiltshire',$keyword_sep_char,'Wiltshire') or $selectedValue='_location-Wiltshire Wiltshire'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="wiltshire">Wiltshire</label></div>
					</div>
					<div class="clr"></div>
				</fieldset>
				<div class="col3">
					<fieldset>
						<legend>Scotland</legend>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="highlandsIslands" value="_location-Highlands and Islands{$keyword_sep_char}Highlands and Islands{$keyword_sep_char}_location-Highlands{$keyword_sep_char}Highlands{$keyword_sep_char}_location-Scotland{$keyword_sep_char}Scotland"><xsl:if test="$selectedValue=concat('_location-Highlands and Islands',$keyword_sep_char,'Highlands and Islands',$keyword_sep_char,'_location-Highlands',$keyword_sep_char,'Highlands',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue=concat('_location-Highlands',$keyword_sep_char,'Highlands',$keyword_sep_char,'_location-Islands',$keyword_sep_char,'Islands') or $selectedValue='_location-Highlands Highlands _location-Islands Islands'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="highlandsIslands">Highlands and Islands</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="northEastScot" value="_location-North East Scotland{$keyword_sep_char}North East Scotland{$keyword_sep_char}_location-Scotland{$keyword_sep_char}Scotland"><xsl:if test="$selectedValue=concat('_location-North East Scotland',$keyword_sep_char,'North East Scotland',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue=concat('_location-North',$keyword_sep_char,'North',$keyword_sep_char,'_location-East',$keyword_sep_char,'East',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue='_location-North North _location-East East _location-Scotland Scotland'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="northEastScot">North East Scotland</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="taysideCentScot" value="_location-Tayside and Central Scotland{$keyword_sep_char}Tayside and Central Scotland{$keyword_sep_char}_location-Tayside{$keyword_sep_char}Tayside{$keyword_sep_char}_location-Central Scotland{$keyword_sep_char}Central Scotland{$keyword_sep_char}_location-Scotland{$keyword_sep_char}Scotland"><xsl:if test="$selectedValue=concat('_location-Tayside and Central Scotland',$keyword_sep_char,'Tayside and Central Scotland',$keyword_sep_char,'_location-Tayside',$keyword_sep_char,'Tayside',$keyword_sep_char,'_location-Central Scotland',$keyword_sep_char,'Central Scotland',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue=concat('_location-Tayside',$keyword_sep_char,'Tayside',$keyword_sep_char,'_location-Central',$keyword_sep_char,'Central',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue='_location-Tayside Tayside _location-Central Central _location-Scotland Scotland'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="taysideCentScot">Tayside and Central Scotland</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="glasgowWestScot" value="_location-Glasgow and West of Scotland{$keyword_sep_char}Glasgow and West of Scotland{$keyword_sep_char}_location-Glasgow{$keyword_sep_char}Glasgow{$keyword_sep_char}_location-West of Scotland{$keyword_sep_char}West of Scotland{$keyword_sep_char}_location-Scotland{$keyword_sep_char}Scotland"><xsl:if test="$selectedValue=concat('_location-Glasgow and West of Scotland',$keyword_sep_char,'Glasgow and West of Scotland',$keyword_sep_char,'_location-Glasgow',$keyword_sep_char,'Glasgow',$keyword_sep_char,'_location-West of Scotland',$keyword_sep_char,'West of Scotland',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue=concat('_location-Glasgow',$keyword_sep_char,'Glasgow',$keyword_sep_char,'_location-West',$keyword_sep_char,'West',$keyword_sep_char,'_location-of',$keyword_sep_char,'of',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue='_location-Glasgow Glasgow _location-West West _location-of of _location-Scotland Scotland'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="glasgowWestScot">Glasgow and West of Scotland</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="edinburghEastScot" value="_location-Edinburgh and East of Scotland{$keyword_sep_char}Edinburgh and East of Scotland{$keyword_sep_char}_location-Edinburgh{$keyword_sep_char}Edinburgh{$keyword_sep_char}_location-East of Scotland{$keyword_sep_char}East of Scotland{$keyword_sep_char}_location-Scotland{$keyword_sep_char}Scotland"><xsl:if test="$selectedValue=concat('_location-Edinburgh and East of Scotland',$keyword_sep_char,'Edinburgh and East of Scotland',$keyword_sep_char,'_location-Edinburgh',$keyword_sep_char,'Edinburgh',$keyword_sep_char,'_location-East of Scotland',$keyword_sep_char,'East of Scotland',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue=concat('_location-Edinburgh',$keyword_sep_char,'Edinburgh',$keyword_sep_char,'_location-East',$keyword_sep_char,'East',$keyword_sep_char,'_location-of',$keyword_sep_char,'of',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue='_location-Edinburgh Edinburgh _location-East East _location-of of _location-Scotland Scotland'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="edinburghEastScot">Edinburgh and East of Scotland</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="southScot" value="_location-South Scotland{$keyword_sep_char}South Scotland{$keyword_sep_char}_location-Scotland{$keyword_sep_char}Scotland"><xsl:if test="$selectedValue=concat('_location-South Scotland',$keyword_sep_char,'South Scotland',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue=concat('_location-South',$keyword_sep_char,'South',$keyword_sep_char,'_location-Scotland',$keyword_sep_char,'Scotland') or $selectedValue='_location-South South _location-Scotland Scotland'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="southScot">South Scotland</label></div>
					</fieldset>	
					<fieldset>
						<legend>Wales</legend>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="northEastWales" value="_location-North East Wales{$keyword_sep_char}North East Wales{$keyword_sep_char}_location-Wales{$keyword_sep_char}Wales"><xsl:if test="$selectedValue=concat('_location-North East Wales',$keyword_sep_char,'North East Wales',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue=concat('_location-North',$keyword_sep_char,'North',$keyword_sep_char,'_location-East',$keyword_sep_char,'East',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue='_location-North North _location-East East _location-Wales Wales'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="northEastWales">North East Wales</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="northWestWales" value="_location-North West Wales{$keyword_sep_char}North West Wales{$keyword_sep_char}_location-Wales{$keyword_sep_char}Wales"><xsl:if test="$selectedValue=concat('_location-North West Wales',$keyword_sep_char,'North West Wales',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue=concat('_location-North',$keyword_sep_char,'North',$keyword_sep_char,'_location-West',$keyword_sep_char,'West',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue='_location-North North _location-West West _location-Wales Wales'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="northWestWales">North West Wales</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="midWales" value="_location-Mid Wales{$keyword_sep_char}Mid Wales{$keyword_sep_char}_location-Wales{$keyword_sep_char}Wales"><xsl:if test="$selectedValue=concat('_location-Mid Wales',$keyword_sep_char,'Mid Wales',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue=concat('_location-Mid',$keyword_sep_char,'Mid',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue='_location-Mid Mid _location-Wales Wales'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="midWales">Mid Wales</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="southEastWales" value="_location-South East Wales{$keyword_sep_char}South East Wales{$keyword_sep_char}_location-Wales{$keyword_sep_char}Wales"><xsl:if test="$selectedValue=concat('_location-South East Wales',$keyword_sep_char,'South East Wales',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue=concat('_location-South',$keyword_sep_char,'South',$keyword_sep_char,'_location-East',$keyword_sep_char,'East',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue='_location-South South _location-East East _location-Wales Wales'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="southEastWales">South East Wales</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="southWestWales" value="_location-South West Wales{$keyword_sep_char}South West Wales{$keyword_sep_char}_location-Wales{$keyword_sep_char}Wales"><xsl:if test="$selectedValue=concat('_location-South West Wales',$keyword_sep_char,'South West Wales',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue=concat('_location-South',$keyword_sep_char,'South',$keyword_sep_char,'_location-West',$keyword_sep_char,'West',$keyword_sep_char,'_location-Wales',$keyword_sep_char,'Wales') or $selectedValue='_location-South South _location-West West _location-Wales Wales'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="southWestWales">South West Wales</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="gogleddOrllewin" value="_location-Gogledd Orllewin{$keyword_sep_char}Gogledd Orllewin{$keyword_sep_char}_location-Cymru{$keyword_sep_char}Cymru"><xsl:if test="$selectedValue=concat('_location-Gogledd Orllewin',$keyword_sep_char,'Gogledd Orllewin',$keyword_sep_char,'_location-Cymru',$keyword_sep_char,'Cymru') or $selectedValue=concat('_location-Gogledd',$keyword_sep_char,'Gogledd',$keyword_sep_char,'_location-Orllewin',$keyword_sep_char,'Orllewin') or $selectedValue='_location-Gogledd Gogledd _location-Orllewin Orllewin'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="gogleddOrllewin">Gogledd Orllewin</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="gogleddDdwyrain" value="_location-Gogledd Ddwyrain{$keyword_sep_char}Gogledd Ddwyrain{$keyword_sep_char}_location-Cymru{$keyword_sep_char}Cymru"><xsl:if test="$selectedValue=concat('_location-Gogledd Ddwyrain',$keyword_sep_char,'Gogledd Ddwyrain',$keyword_sep_char,'_location-Cymru',$keyword_sep_char,'Cymru') or $selectedValue=concat('_location-Gogledd',$keyword_sep_char,'Gogledd',$keyword_sep_char,'_location-Ddwyrain',$keyword_sep_char,'Ddwyrain') or $selectedValue='_location-Gogledd Gogledd _location-Ddwyrain Ddwyrain'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="gogleddDdwyrain">Gogledd Ddwyrain</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="canolbarth" value="_location-Canolbarth{$keyword_sep_char}Canolbarth{$keyword_sep_char}_location-Cymru{$keyword_sep_char}Cymru"><xsl:if test="$selectedValue=concat('_location-Canolbarth',$keyword_sep_char,'Canolbarth',$keyword_sep_char,'_location-Cymru',$keyword_sep_char,'Cymru') or $selectedValue=concat('_location-Canolbarth',$keyword_sep_char,'Canolbarth') or $selectedValue='_location-Canolbarth Canolbarth'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="canolbarth">Canolbarth</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="deOrllewin" value="_location-De Orllewin{$keyword_sep_char}De Orllewin{$keyword_sep_char}_location-Cymru{$keyword_sep_char}Cymru"><xsl:if test="$selectedValue=concat('_location-De Orllewin',$keyword_sep_char,'De Orllewin',$keyword_sep_char,'_location-Cymru',$keyword_sep_char,'Cymru') or $selectedValue=concat('_location-De',$keyword_sep_char,'De',$keyword_sep_char,'_location-Orllewin',$keyword_sep_char,'Orllewin') or $selectedValue='_location-De De _location-Orllewin Orllewin'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="deOrllewin">De Orllewin</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="deDdwyrain" value="_location-De Ddwyrain{$keyword_sep_char}De Ddwyrain{$keyword_sep_char}_location-Cymru{$keyword_sep_char}Cymru"><xsl:if test="$selectedValue=concat('_location-De Ddwyrain',$keyword_sep_char,'De Ddwyrain',$keyword_sep_char,'_location-Cymru',$keyword_sep_char,'Cymru') or $selectedValue=concat('_location-De',$keyword_sep_char,'De',$keyword_sep_char,'_location-Ddwyrain',$keyword_sep_char,'Ddwyrain') or $selectedValue='_location-De De _location-Ddwyrain Ddwyrain'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="deDdwyrain">De Ddwyrain</label></div>
					</fieldset>
				</div>
				<div class="col4">
					<fieldset>
						<legend>Channel Islands</legend>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="guernsey" value="_location-Guernsey{$keyword_sep_char}Guernsey{$keyword_sep_char}_location-Channel Islands{$keyword_sep_char}Channel Islands"><xsl:if test="$selectedValue=concat('_location-Guernsey',$keyword_sep_char,'Guernsey',$keyword_sep_char,'_location-Channel Islands',$keyword_sep_char,'Channel Islands') or $selectedValue=concat('_location-Guernsey',$keyword_sep_char,'Guernsey') or $selectedValue='_location-Guernsey Guernsey'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="guernsey">Guernsey</label></div>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="jersey" value="_location-Jersey{$keyword_sep_char}Jersey{$keyword_sep_char}_location-Channel Islands{$keyword_sep_char}Channel Islands"><xsl:if test="$selectedValue=concat('_location-Jersey',$keyword_sep_char,'Jersey',$keyword_sep_char,'_location-Channel Islands',$keyword_sep_char,'Channel Islands') or $selectedValue=concat('_location-Jersey',$keyword_sep_char,'Jersey') or $selectedValue='_location-Jersey Jersey'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="jersey">Jersey</label></div>
					</fieldset>	
					<fieldset>
						<legend>Isle of Man</legend>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="isleOfMan" value="_location-Isle of Man{$keyword_sep_char}Isle of Man"><xsl:if test="$selectedValue=concat('_location-Isle of Man',$keyword_sep_char,'Isle of Man') or $selectedValue=concat('_location-Isle',$keyword_sep_char,'Isle',$keyword_sep_char,'_location-of',$keyword_sep_char,'of',$keyword_sep_char,'_location-Man',$keyword_sep_char,'Man') or $selectedValue='_location-Isle Isle _location-of of _location-Man Man'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="isleOfMan">Isle of Man</label></div>
					</fieldset>		
					<fieldset>
						<legend>Northern Ireland</legend>
						<div class="row"><input type="radio" class="radio" name="{$fieldName}" id="northernIreland" value="_location-Northern Ireland{$keyword_sep_char}Northern Ireland"><xsl:if test="$selectedValue=concat('_location-Northern Ireland',$keyword_sep_char,'Northern Ireland') or $selectedValue=concat('_location-Northern',$keyword_sep_char,'Northern',$keyword_sep_char,'_location-Ireland',$keyword_sep_char,'Ireland') or $selectedValue='_location-Northern Northern _location-Ireland Ireland'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="northernIreland">Northern Ireland</label></div>
					</fieldset>	
				</div>
			</fieldset>
		</div>
		<div class="clr"></div>
		<div id="nonUKLocation">
			<fieldset>
				<!-- This is now on the Add Memory form only - next to the Extra info text box. 
					 Have changed this to in effect act as selecting nothing for location.
				-->
				<div class="row megaRow"><input type="radio" class="radio" name="{$fieldName}" id="otherLocation" value="_location-Non-Uk" onclick="fnUpdateFlashMap()"><xsl:if test="$selectedValue='_location-Non-Uk'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input><label for="otherLocation"> Non-UK location</label></div>
			</fieldset>
		</div>
		<div class="clr"></div>
	</xsl:template>

</xsl:stylesheet>
