<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:internal="http://www.bbc.co.uk/dna:internal" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc internal">
    
    <doc:documentation>
        <doc:purpose>
            Convert a DNA DATE node to a DATE node +BST (e.g 1 hour in advance)
        </doc:purpose>
        <doc:context>
            Every DNA DATE node can be passed through this
        </doc:context>
        <doc:notes>
            Craziness comes when an hour increment increases the day and possibly the month. Although BST should never affect the year,
            the year logic was added.
        </doc:notes>
    </doc:documentation>
    
    <internal:lookup>
        <internal:month key="01" value="January" />
        <internal:month key="02" value="February" />
        <internal:month key="03" value="March" />
        <internal:month key="04" value="April" />
        <internal:month key="05" value="May" />
        <internal:month key="06" value="June" />
        <internal:month key="07" value="July" />
        <internal:month key="08" value="August" />
        <internal:month key="09" value="September" />
        <internal:month key="10" value="October" />
        <internal:month key="11" value="November" />
        <internal:month key="12" value="December" />
    </internal:lookup>
    
    <internal:lookup>
        <internal:day key="0" value="Sunday" />
        <internal:day key="1" value="Monday" />
        <internal:day key="2" value="Tuesday" />
        <internal:day key="3" value="Wednesday" />
        <internal:day key="4" value="Thursday" />
        <internal:day key="5" value="Friday" />
        <internal:day key="6" value="Saturday" />
    </internal:lookup>
    
    <xsl:template match="DATE" mode="library_date_converttobst">
        
        <xsl:choose>
            <xsl:when test="(@HOURS + 1) > 23">
                <!-- day has incremented -->
                
                <xsl:variable name="lastDay">
                    <xsl:call-template name="library_date_lastdayofmonth">
                        <xsl:with-param name="month" select="@MONTH" />
                        <xsl:with-param name="year" select="@YEAR" />
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:choose>
                    <xsl:when test="(@DAY + 1) > $lastDay">
                        <!-- month has incremented -->
                        
                        <xsl:choose>
                            <xsl:when test="(@MONTH + 1) > 12">
                                <!-- year has incremented -->
                                <xsl:variable name="month" select="01" />
                                <xsl:variable name="year" select="@YEAR + 1" />
                                <xsl:variable name="dayname">
                                    <xsl:call-template name="library_date_dayoftheweek">
                                        <xsl:with-param name="month" select="$month" />
                                        <xsl:with-param name="year" select="@YEAR" />
                                        <xsl:with-param name="day" select="01" />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="monthname" select="string(document('')/*/internal:lookup/internal:month[@key = $month]/@value)"/>
                                
                                <DATE DAYNAME="{@DAYNAME}" SECONDS="{@SECONDS}" MINUTES="{@MINUTES}" HOURS="00"  DAY="01" MONTH="01" MONTHNAME="{$monthname}" YEAR="{$year}" SORT="{concat($year, 01, '01', '00', @MINUTES, @SECONDS)}" />
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- no year change, only month and day -->

                                <xsl:variable name="month" select="format-number(@MONTH + 1, '00')" />
                                <xsl:variable name="dayname">
                                    <xsl:call-template name="library_date_dayoftheweek">
                                        <xsl:with-param name="month" select="$month" />
                                        <xsl:with-param name="year" select="@YEAR" />
                                        <xsl:with-param name="day" select="1" />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="monthname" select="string(document('')/*/internal:lookup/internal:month[@key = $month]/@value)"/>
                                
                                <DATE DAYNAME="{$dayname}" SECONDS="{@SECONDS}" MINUTES="{@MINUTES}" HOURS="00"  DAY="01" MONTH="{$month}" MONTHNAME="{$monthname}" YEAR="{@YEAR}" SORT="{concat(@YEAR, $month, '01', '00', @MINUTES, @SECONDS)}" />
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- no month change, only day -->
                        <xsl:variable name="day" select="format-number(@DAY + 1, '00')" />
                        <xsl:variable name="dayname">
                            <xsl:call-template name="library_date_dayoftheweek">
                                <xsl:with-param name="month" select="@MONTH" />
                                <xsl:with-param name="year" select="@YEAR" />
                                <xsl:with-param name="day" select="$day" />
                            </xsl:call-template>
                        </xsl:variable>
                        <DATE DAYNAME="{$dayname}" SECONDS="{@SECONDS}" MINUTES="{@MINUTES}" HOURS="00"  DAY="{$day}" MONTH="{@MONTH}" MONTHNAME="{@MONTHNAME}" YEAR="{@YEAR}" SORT="{concat(@YEAR, @MONTH, $day, '00', @MINUTES, @SECONDS)}" />
                        
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            <xsl:otherwise>
                <!-- no day change -->
                <xsl:variable name="hour" select="format-number(@HOURS + 1, '00')" />
                <DATE DAYNAME="{@DAYNAME}" SECONDS="{@SECONDS}" MINUTES="{@MINUTES}" HOURS="{$hour}"  DAY="{@DAY}" MONTH="{@MONTH}" MONTHNAME="{@MONTHNAME}" YEAR="{@YEAR}" SORT="{concat(@YEAR, @MONTH, @DAY, $hour, @MINUTES, @SECONDS)}" />
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="library_date_lastdayofmonth">
        <xsl:param name="month" />
        <xsl:param name="year" />
        
        <xsl:choose>
            <xsl:when test="$month = 2 and not($year mod 4) and ($year mod 100 or not($year mod 400))">
                <xsl:value-of select="29"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring('312831303130313130313031', 2 * $month - 1, 2)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="library_date_dayoftheweek" >
        <xsl:param name="year" />
        <xsl:param name="month" />
        <xsl:param name="day" />
        
        <xsl:variable name="a" select="floor((14 - $month) div 12)" />
        <xsl:variable name="y" select="$year - $a" />
        <xsl:variable name="m" select="$month + 12 * $a - 2" />
        
        <xsl:variable name="dayNumber" select="($day + $y + floor($y div 4) - floor($y div 100) + floor($y div 400) + floor((31 * $m) div 12)) mod 7"/>
        
        <xsl:value-of select="string(document('')/*/internal:lookup/internal:day[@key = $dayNumber]/@value)"/>
    </xsl:template>
    
</xsl:stylesheet>