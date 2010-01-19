<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitedisplayname">606</xsl:variable>
	<xsl:variable name="sitename">606</xsl:variable>
	<xsl:variable name="skinname">606</xsl:variable>
	<xsl:variable name="root">/dna/606/</xsl:variable>
	<xsl:variable name="sso_serviceid_path">606</xsl:variable>
	<xsl:variable name="sso_serviceid_link">606</xsl:variable>
	<xsl:variable name="sso_assets_path">/606/2/sso_resources</xsl:variable>
	<xsl:variable name="enable_rss">N</xsl:variable>
	
	<xsl:variable name="multiposts_posts_per_page">50</xsl:variable>
	
	<xsl:variable name="imagesource">
	<xsl:choose>
		<xsl:when test="/H2G2/SERVERNAME = $development_server">http://www.bbc.co.uk/606/2/refresh/images/</xsl:when>
		<!--[FIXME: revert, should be like live]-->
		<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www.bbc.co.uk/606/2/refresh/images/</xsl:when>
		<xsl:otherwise>http://www.bbc.co.uk/606/2/refresh/images/</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="smileysource606">
		<xsl:value-of select="concat($imagesource, 'smileys/')"/>
	</xsl:variable>
	
	<xsl:variable name="cpshome" select="'http://news.bbc.co.uk/sport1/hi/606/default.stm'"/>
	<xsl:variable name="smileysource" select="concat($imagesource, 'smileys/')"/>
	<!--
	<xsl:variable name="smileysource" select="'http://www.bbc.co.uk/dnaimages/boards/images/emoticons/'"/>
	-->
	<!-- for smileys see: http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html -->
	
	<xsl:variable name="graphics" select="$imagesource"/>
	<xsl:variable name="site_number">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[NAME='606']/@ID" />
	</xsl:variable>
	
	<xsl:variable name="test_IsHost" select="/H2G2/VIEWING-USER/USER/GROUPS/HOST or ($superuser = 1)"/>
	
	<xsl:variable name="articlesearchlink">ArticleSearch?contenttype=-1&amp;phrase=</xsl:variable>
	
	<xsl:variable name="sport">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='ARTICLE'"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/SPORT" /></xsl:when>
			<xsl:when test="/H2G2/@TYPE='TYPED-ARTICLE'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']">
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='football'">Football</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='cricket'">Cricket</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='rugby_union'">Rugby Union</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='rugby_league'">Rugby League</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='tennis'">Tennis</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='golf'">Golf</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='motorsport'">Motorsport</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='boxing'">Boxing</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='athletics'">Athletics</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='snooker'">Snooker</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='horse_racing'">Horse Racing</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='cycling'">Cycling</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='disability_sport'">Disability Sport</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE='other'">Othersport</xsl:when>
						</xsl:choose>						
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text()" /></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="sport_converted">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Football' or /H2G2/ARTICLE/GUIDE/SPORT='football'">football</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Cricket' or /H2G2/ARTICLE/GUIDE/SPORT='cricket'">cricket</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Rugby Union' or /H2G2/ARTICLE/GUIDE/SPORT='Rugby union' or /H2G2/ARTICLE/GUIDE/SPORT='rugby union'">rugbyunion</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Rugby League' or/H2G2/ARTICLE/GUIDE/SPORT='Rugby league' or /H2G2/ARTICLE/GUIDE/SPORT='rugby league'">rugbyleague</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Tennis' or /H2G2/ARTICLE/GUIDE/SPORT='tennis'">tennis</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Golf' or /H2G2/ARTICLE/GUIDE/SPORT='golf'">golf</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Motorsport' or /H2G2/ARTICLE/GUIDE/SPORT='motorsport'">motorsport</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Boxing' or /H2G2/ARTICLE/GUIDE/SPORT='boxing'">boxing</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Athletics' or /H2G2/ARTICLE/GUIDE/SPORT='athletics'">athletics</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Snooker' or /H2G2/ARTICLE/GUIDE/SPORT='snooker'">snooker</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Horse Racing'or /H2G2/ARTICLE/GUIDE/SPORT='Horse racing' or /H2G2/ARTICLE/GUIDE/SPORT='horse racing'">horseracing</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Cycling' or /H2G2/ARTICLE/GUIDE/SPORT='cycling'">cycling</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Disability Sport' or /H2G2/ARTICLE/GUIDE/SPORT='Disability sport' or /H2G2/ARTICLE/GUIDE/SPORT='disability sport'">disabilitysport</xsl:when>
			<xsl:otherwise>other</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="sports_info">
		<sports>
			<sport name="Football" converted="football">
				<a href="http://news.bbc.co.uk/sport1/hi/football/default.stm">BBC Sport Football</a>
			</sport>
			<sport name="Cricket" converted="cricket">
				<a href="http://news.bbc.co.uk/sport1/hi/cricket/default.stm">BBC Sport Cricket</a>
			</sport>
			<sport name="Rugby Union" converted="rugbyunion">
				<a href="http://news.bbc.co.uk/sport1/hi/rugby_union/default.stm">BBC Sport Rugby Union</a>
			</sport>
			<sport name="Rugby League" converted="rugbyleague">
				<a href="http://news.bbc.co.uk/sport1/hi/rugby_league/default.stm">BBC Sport Rugby League</a>
			</sport>
			<sport name="Tennis" converted="tennis">
				<a href="http://news.bbc.co.uk/sport1/hi/tennis/default.stm">BBC Sport Tennis</a>
			</sport>
			<sport name="Golf" converted="golf">
				<a href="http://news.bbc.co.uk/sport1/hi/golf/default.stm">BBC Sport Golf</a>
			</sport>
			<sport name="Motorsport" converted="motorsport">
				<a href="http://news.bbc.co.uk/sport1/hi/motorsport/default.stm">BBC Sport Motorsport</a>
			</sport>
			<sport name="Boxing" converted="boxing">
				<a href="http://news.bbc.co.uk/sport1/hi/boxing/default.stm">BBC Sport Boxing</a>
			</sport>
			<sport name="Athletics" converted="athletics">
				<a href="http://news.bbc.co.uk/sport1/hi/athletics/default.stm">BBC Sport Athletics</a>
			</sport>
			<sport name="Snooker" converted="snooker">
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/snooker/default.stm">BBC Sport Snooker</a>
			</sport>
			<sport name="Horse Racing" converted="horseracing">
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/horse_racing/default.stm">BBC Sport Horse Racing</a>
			</sport>
			<sport name="Cycling" converted="cycling">
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/cycling/default.stm">BBC Sport Cycling</a>
			</sport>
			<sport name="Disability Sport" converted="disabilitysport">
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/disability_sport/default.stm">BBC Sport Disability Sport</a>
			</sport>
			<sport name="Other Sport" converted="other">
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/default.stm">BBC Sport Other Sport</a>
			</sport>
		</sports>
	</xsl:variable>
	
	<xsl:variable name="competition" select="/H2G2/ARTICLE/GUIDE/COMPETITION"/>
		
	<xsl:variable name="pagetype">
	<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='ARTICLE'">
		article
		</xsl:when>
		<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
		multiposts
		</xsl:when>
	</xsl:choose>
	</xsl:variable>
	
		
	<!--===============   SERVER    =====================-->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
	<xsl:variable name="dna_server">http://dnadev.national.bu.bbc.co.uk</xsl:variable>
	<xsl:variable name="development_server">OPS-DNA1</xsl:variable>
	<xsl:variable name="staging_server">NMSDNA0</xsl:variable>
	
	
	
<!--=========  Related BBC links (regional promos)   =========-->
<xsl:variable name="hometeam">
	<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/GUIDE/HOMETEAMOTHER/text()">
			<xsl:value-of select="/H2G2/ARTICLE/GUIDE/HOMETEAMOTHER/text()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/H2G2/ARTICLE/GUIDE/HOMETEAM/text()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="awayteam">
	<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/GUIDE/AWAYTEAMOTHER/text()">
			<xsl:value-of select="/H2G2/ARTICLE/GUIDE/AWAYTEAMOTHER/text()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/H2G2/ARTICLE/GUIDE/AWAYTEAM/text()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="currentteam">
	<xsl:value-of select="/H2G2/ARTICLE/GUIDE/CURRENTTEAM/text()"/>
</xsl:variable>

<xsl:variable name="team">
	<xsl:choose>
		<xsl:when test="$article_subtype='match_report'"><xsl:value-of select="$hometeam"/></xsl:when>
		<!--
		<xsl:when test="$article_subtype='team_profile'"><xsl:value-of select="/H2G2/ARTICLE/SUBJECT/text()"/></xsl:when>
		-->
		<xsl:otherwise><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAM/text()" mode="variablevalue"/></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="team2">
	<xsl:choose>
		<xsl:when test="$article_subtype='match_report'"><xsl:value-of select="$awayteam"/></xsl:when>
		<xsl:when test="$article_subtype='player_profile'"><xsl:value-of select="$currentteam"/></xsl:when>
	</xsl:choose>
</xsl:variable>




<!-- note: 
	dropdownname not used yet but could use it to generate code for drop downs 
	also: need to add country/region - i.e england, wales, scotland	
-->
<xsl:variable name="teamsbysport">
	<sports>
		<!-- FOOTBALL -->
		<sport type="Football">
			<team fullname="Aberdeen" dropdownname="Aberdeen">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Accrington Stanley" dropdownname="Accrington Stanley">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Airdrie United" dropdownname="Airdrie Utd">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Albion Rovers" dropdownname="Albion">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Aldershot Town" dropdownname="Aldershot">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="Alloa" dropdownname="Alloa">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Altrincham" dropdownname="Altrincham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Arbroath" dropdownname="Arbroath">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Arsenal" dropdownname="Arsenal">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Aston Villa" dropdownname="Aston Villa">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/birmingham/sport/index.shtml</url>
					<image>birmingham</image>
					<text>More on this team at the BBC website for Birmingham</text>
				</relatedpromo>
			</team>
			<team fullname="Ayr United" dropdownname="Ayr">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Barnet" dropdownname="Barnet">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Barnsley" dropdownname="Barnsley">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southyorkshire/sport/index.shtml</url>
					<image>southyorkshire</image>
					<text>More on this team at the BBC website for South Yorkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Berwick Rangers" dropdownname="Berwick">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Birmingham City" dropdownname="Birmingham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/birmingham/sport/index.shtml</url>
					<image>birmingham</image>
					<text>More on this team at the BBC website for Birmingham</text>
				</relatedpromo>
			</team>
			<team fullname="Blackburn Rovers" dropdownname="Blackburn">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Blackpool" dropdownname="Blackpool">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Bolton Wanderers" dropdownname="Bolton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Boston United" dropdownname="Boston Utd">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lincolnshire/sport/index.shtml</url>
					<image>lincolnshire</image>
					<text>More on this team at the BBC website for Lincolnshire</text>
				</relatedpromo>
			</team>
			<team fullname="Bournemouth" dropdownname="Bournemouth">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/dorset/sport/index.shtml</url>
					<image>dorset</image>
					<text>More on this team at the BBC website for Dorset</text>
				</relatedpromo>
			</team>
			<team fullname="Bradford City" dropdownname="Bradford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Brechin City" dropdownname="Brechin">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Brentford" dropdownname="Brentford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Brighton and Hove Albion" dropdownname="Brighton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="Bristol City" dropdownname="Bristol City">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bristol/sport/index.shtml</url>
					<image>bristol</image>
					<text>More on this team at the BBC website for Bristol</text>
				</relatedpromo>
			</team>
			<team fullname="Bristol Rovers" dropdownname="Bristol Rovers">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bristol/sport/index.shtml</url>
					<image>bristol</image>
					<text>More on this team at the BBC website for Bristol</text>
				</relatedpromo>
			</team>
			<team fullname="Burnley" dropdownname="Burnley">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Burton Albion" dropdownname="Burton Albion">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/stoke/sport/index.shtml</url>
					<image>stoke</image>
					<text>More on this team at the BBC website for Stoke</text>
				</relatedpromo>
			</team>
			<team fullname="Bury" dropdownname="Bury">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Cambridge United" dropdownname="Cambridge Utd">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/cambridgeshire/sport/index.shtml</url>
					<image>cambridgeshire</image>
					<text>More on this team at the BBC website for Cambridgeshire</text>
				</relatedpromo>
			</team>
			<team fullname="Cardiff City" dropdownname="Cardiff">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/sport/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Carlisle United" dropdownname="Carlisle">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/cumbria /sport/index.shtml</url>
					<image>cumbria</image>
					<text>More on this team at the BBC website for Cumbria</text>
				</relatedpromo>
			</team>
			<team fullname="Celtic" dropdownname="Celtic">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Charlton Athletic" dropdownname="Charlton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Chelsea" dropdownname="Chelsea">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Cheltenham Town" dropdownname="Cheltenham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/gloucestershire/sport/index.shtml</url>
					<image>gloucestershire</image>
					<text>More on this team at the BBC website for Gloucestershire</text>
				</relatedpromo>
			</team>
			<team fullname="Chester City" dropdownname="Chester">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/liverpool/sport/index.shtml</url>
					<image>liverpool</image>
					<text>More on this team at the BBC website for Liverpool</text>
				</relatedpromo>
			</team>
			<team fullname="Chesterfield" dropdownname="Chesterfield">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/derby/sport/index.shtml</url>
					<image>derby</image>
					<text>More on this team at the BBC website for Derby</text>
				</relatedpromo>
			</team>
			<team fullname="Clyde" dropdownname="Clyde">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Colchester United" dropdownname="Colchester">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/essex/sport/index.shtml</url>
					<image>essex</image>
					<text>More on this team at the BBC website for Essex</text>
				</relatedpromo>
			</team>
			<team fullname="Coventry City" dropdownname="Coventry">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/coventry/sport/index.shtml</url>
					<image>coventry</image>
					<text>More on this team at the BBC website for Coventry</text>
				</relatedpromo>
			</team>
			<team fullname="Cowdenbeath" dropdownname="Cowdenbeath">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Crawley Town" dropdownname="Crawley Town">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="Crewe Alexandra" dropdownname="Crewe">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/stoke/sport/index.shtml</url>
					<image>stoke</image>
					<text>More on this team at the BBC website for Stoke</text>
				</relatedpromo>
			</team>
			<team fullname="Crystal Palace" dropdownname="Crystal Palace">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Dagenham and Redbridge" dropdownname="Dag &amp; Red">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/essex/sport/index.shtml</url>
					<image>essex</image>
					<text>More on this team at the BBC website for Essex</text>
				</relatedpromo>
			</team>
			<team fullname="Darlington" dropdownname="Darlington">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/tees/sport/index.shtml</url>
					<image>tees</image>
					<text>More on this team at the BBC website for Tees</text>
				</relatedpromo>
			</team>
			<team fullname="Derby County" dropdownname="Derby">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/derby/sport/index.shtml</url>
					<image>derby</image>
					<text>More on this team at the BBC website for Derby</text>
				</relatedpromo>
			</team>
			<team fullname="Doncaster Rovers" dropdownname="Doncaster">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southyorkshire/sport/index.shtml</url>
					<image>southyorkshire</image>
					<text>More on this team at the BBC website for South Yorkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Dumbarton" dropdownname="Dumbarton">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Dundee" dropdownname="Dundee">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Dundee United" dropdownname="Dundee Utd">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Dunfermline Athletic" dropdownname="Dunfermline">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="East Fife" dropdownname="East Fife">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="East Stirlingshire" dropdownname="East Stirling">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Elgin City" dropdownname="Elgin">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="England" dropdownname="England">
				<relatedpromo type="bbc.co.uk/england">
					<url>http://www.bbc.co.uk/england/</url>
					<image>england</image>
					<text>Find the latest news and sport on your local BBC site </text>
				</relatedpromo>
			</team>
			<team fullname="Everton" dropdownname="Everton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/liverpool/sport/index.shtml</url>
					<image>liverpool</image>
					<text>More on this team at the BBC website for Liverpool</text>
				</relatedpromo>
			</team>
			<team fullname="Exeter City" dropdownname="Exeter">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/devon/sport/index.shtml</url>
					<image>devon</image>
					<text>More on this team at the BBC website for Devon</text>
				</relatedpromo>
			</team>
			<team fullname="Falkirk" dropdownname="Falkirk">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Forest Green Rovers" dropdownname="Forest Green">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/gloucestershire/sport/index.shtml</url>
					<image>gloucestershire</image>
					<text>More on this team at the BBC website for Gloucestershire</text>
				</relatedpromo>
			</team>
			<team fullname="Forfar Athletic" dropdownname="Forfar">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Fulham" dropdownname="Fulham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Gillingham" dropdownname="Gillingham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/kent/sport/index.shtml</url>
					<image>kent</image>
					<text>More on this team at the BBC website for Kent</text>
				</relatedpromo>
			</team>
			<team fullname="Gravesend and Northfleet" dropdownname="Gravesend">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/kent/sport/index.shtml</url>
					<image>kent</image>
					<text>More on this team at the BBC website for Kent</text>
				</relatedpromo>
			</team>
			<team fullname="Grays Athletic" dropdownname="Grays Athletic">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/essex/sport/index.shtml</url>
					<image>essex</image>
					<text>More on this team at the BBC website for Essex</text>
				</relatedpromo>
			</team>
			<team fullname="Gretna" dropdownname="Gretna">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Grimsby Town" dropdownname="Grimsby">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/humber/sport/index.shtml</url>
					<image>humber</image>
					<text>More on this team at the BBC website for Humberside</text>
				</relatedpromo>
			</team>
			<team fullname="Halifax Town" dropdownname="Halifax">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Hamilton Academic" dropdownname="Hamilton">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Hartlepool United" dropdownname="Hartlepool">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/tees/sport/index.shtml</url>
					<image>tees</image>
					<text>More on this team at the BBC website for Tees</text>
				</relatedpromo>
			</team>
			<team fullname="Heart of Midlothian" dropdownname="Hearts">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Hereford United" dropdownname="Hereford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/herefordandworcester/sport/index.shtml</url>
					<image>herefordandworcester</image>
					<text>More on this team at the BBC website for Hereford &amp; Worcester</text>
				</relatedpromo>
			</team>
			<team fullname="Hibernian" dropdownname="Hibernian">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Huddersfield Town" dropdownname="Huddersfield">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Hull City" dropdownname="Hull">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/humber/sport/index.shtml</url>
					<image>humber</image>
					<text>More on this team at the BBC website for Humberside</text>
				</relatedpromo>
			</team>
			<team fullname="Inverness Caledonian Thistle" dropdownname="Inverness CT">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Ipswich Town" dropdownname="Ipswich">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/suffolk/sport/index.shtml</url>
					<image>suffolk</image>
					<text>More on this team at the BBC website for Suffolk</text>
				</relatedpromo>
			</team>
			<team fullname="Kidderminster Harriers" dropdownname="Kidderminster">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/herefordandworcester/sport/index.shtml</url>
					<image>herefordandworcester</image>
					<text>More on this team at the BBC website for Hereford &amp; Worcester</text>
				</relatedpromo>
			</team>
			<team fullname="Kilmarnock" dropdownname="Kilmarnock">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Leeds United" dropdownname="Leeds">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/leeds/sport/index.shtml</url>
					<image>leeds</image>
					<text>More on this team at the BBC website for Leeds</text>
				</relatedpromo>
			</team>
			<team fullname="Leicester City" dropdownname="Leicester">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/leicester/sport/index.shtml</url>
					<image>leicester</image>
					<text>More on this team at the BBC website for Leicester</text>
				</relatedpromo>
			</team>
			<team fullname="Leyton Orient" dropdownname="Leyton Orient">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Lincoln City" dropdownname="Lincoln City">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lincolnshire/sport/index.shtml</url>
					<image>lincolnshire</image>
					<text>More on this team at the BBC website for Lincolnshire</text>
				</relatedpromo>
			</team>
			<team fullname="Liverpool" dropdownname="Liverpool">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/liverpool/sport/index.shtml</url>
					<image>liverpool</image>
					<text>More on this team at the BBC website for Liverpool</text>
				</relatedpromo>
			</team>
			<team fullname="Livingston" dropdownname="Livingston">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Luton Town" dropdownname="Luton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="Macclesfield Town" dropdownname="Macclesfield">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Manchester City" dropdownname="Man City">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Manchester United" dropdownname="Man Utd">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Mansfield Town" dropdownname="Mansfield">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/nottingham/sport/index.shtml</url>
					<image>nottingham</image>
					<text>More on this team at the BBC website for Nottingham</text>
				</relatedpromo>
			</team>
			<team fullname="Middlesbrough" dropdownname="Middlesbrough">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/tees/sport/index.shtml</url>
					<image>tees</image>
					<text>More on this team at the BBC website for Tees</text>
				</relatedpromo>
			</team>
			<team fullname="Millwall" dropdownname="Millwall">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Milton Keynes Dons" dropdownname="Milton Keynes Dons">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="Montrose" dropdownname="Montrose">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Morecambe" dropdownname="Morecambe">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Morton" dropdownname="Morton">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Motherwell" dropdownname="Motherwell">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Newcastle United" dropdownname="Newcastle">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/tyne/sport/index.shtml</url>
					<image>tyne</image>
					<text>More on this team at the BBC website for Tyne</text>
				</relatedpromo>
			</team>
			<team fullname="Northampton Town" dropdownname="Northampton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/northamptonshire/sport/index.shtml</url>
					<image>northamptonshire</image>
					<text>More on this team at the BBC website for Northamptonshire</text>
				</relatedpromo>
			</team>
			<team fullname="Northern Ireland" dropdownname="Northern Ireland">
				<relatedpromo type="BBC Northern Ireland">
					<url>http://www.bbc.co.uk/northernireland/</url>
					<image>northernireland</image>
					<text>Find the latest Northern Ireland sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Northwich Victoria" dropdownname="Northwich">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/liverpool/sport/index.shtml</url>
					<image>liverpool</image>
					<text>More on this team at the BBC website for Liverpool</text>
				</relatedpromo>
			</team>
			<team fullname="Norwich City" dropdownname="Norwich">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/norfolk/sport/index.shtml</url>
					<image>norfolk</image>
					<text>More on this team at the BBC website for Norfolk</text>
				</relatedpromo>
			</team>
			<team fullname="Nottingham Forest" dropdownname="Nottm Forest">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/nottingham/sport/index.shtml</url>
					<image>nottingham</image>
					<text>More on this team at the BBC website for Nottingham</text>
				</relatedpromo>
			</team>
			<team fullname="Notts County" dropdownname="Notts County">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/nottingham/sport/index.shtml</url>
					<image>nottingham</image>
					<text>More on this team at the BBC website for Nottingham</text>
				</relatedpromo>
			</team>
			<team fullname="Oldham Athletic" dropdownname="Oldham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Oxford United" dropdownname="Oxford Utd">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/oxford/sport/index.shtml</url>
					<image>oxford</image>
					<text>More on this team at the BBC website for Oxford</text>
				</relatedpromo>
			</team>
			<team fullname="Partick Thistle" dropdownname="Partick">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Peterborough United" dropdownname="Peterborough">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/cambridgeshire/sport/index.shtml</url>
					<image>cambridgeshire</image>
					<text>More on this team at the BBC website for Cambridgeshire</text>
				</relatedpromo>
			</team>
			<team fullname="Peterhead" dropdownname="Peterhead">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Plymouth Argyle" dropdownname="Plymouth">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/devon/sport/index.shtml</url>
					<image>devon</image>
					<text>More on this team at the BBC website for Devon</text>
				</relatedpromo>
			</team>
			<team fullname="Port Vale" dropdownname="Port Vale">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/stoke/sport/index.shtml</url>
					<image>stoke</image>
					<text>More on this team at the BBC website for Stoke</text>
				</relatedpromo>
			</team>
			<team fullname="Portsmouth" dropdownname="Portsmouth">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/hampshire/sport/index.shtml</url>
					<image>hampshire</image>
					<text>More on this team at the BBC website for Hampshire</text>
				</relatedpromo>
			</team>
			<team fullname="Preston North End" dropdownname="Preston">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Queens Park Rangers" dropdownname="QPR">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Queen of the South" dropdownname="Queen of South">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Queens Park" dropdownname="Queens Park">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Raith Rovers" dropdownname="Raith">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Rangers" dropdownname="Rangers">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Reading" dropdownname="Reading">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/berkshire/sport/index.shtml</url>
					<image>berkshire</image>
					<text>More on this team at the BBC website for Berkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Republic of Ireland" dropdownname="Republic of Ireland">
				<relatedpromo type="Irish Football">
					<url>http://news.bbc.co.uk/sport1/hi/football/irish/default.stm</url>
					<image>irishfootball</image>
					<text>Find the latest news and sport on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Rochdale" dropdownname="Rochdale">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Ross County" dropdownname="Ross County">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Rotherham United" dropdownname="Rotherham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southyorkshire/sport/index.shtml</url>
					<image>southyorkshire</image>
					<text>More on this team at the BBC website for South Yorkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Rushden and Diamonds" dropdownname="Rushden &amp; Dmonds">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/northamptonshire/sport/index.shtml</url>
					<image>northamptonshire</image>
					<text>More on this team at the BBC website for Northamptonshire</text>
				</relatedpromo>
			</team>
			<team fullname="Scotland" dropdownname="Scotland">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Scunthorpe United" dropdownname="Scunthorpe">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/humber/sport/index.shtml</url>
					<image>humber</image>
					<text>More on this team at the BBC website for Humberside</text>
				</relatedpromo>
			</team>
			<team fullname="Sheffield United" dropdownname="Sheff Utd">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southyorkshire/sport/index.shtml</url>
					<image>southyorkshire</image>
					<text>More on this team at the BBC website for South Yorkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Sheffield Wednesday" dropdownname="Sheff Wed">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southyorkshire/sport/index.shtml</url>
					<image>southyorkshire</image>
					<text>More on this team at the BBC website for South Yorkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Shrewsbury Town" dropdownname="Shrewsbury">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/shropshire/sport/index.shtml</url>
					<image>shropshire</image>
					<text>More on this team at the BBC website for Shropshire</text>
				</relatedpromo>
			</team>
			<team fullname="Southampton" dropdownname="Southampton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/hampshire/sport/index.shtml</url>
					<image>hampshire</image>
					<text>More on this team at the BBC website for Hampshire</text>
				</relatedpromo>
			</team>
			<team fullname="Southend United" dropdownname="Southend">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/essex/sport/index.shtml</url>
					<image>essex</image>
					<text>More on this team at the BBC website for Essex</text>
				</relatedpromo>
			</team>
			<team fullname="Southport" dropdownname="Southport">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="St Albans City" dropdownname="St Albans">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="St Johnstone" dropdownname="St Johnstone">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="St Mirren" dropdownname="St Mirren">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Stafford Rangers" dropdownname="Stafford Rangers">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/stoke/sport/index.shtml</url>
					<image>stoke</image>
					<text>More on this team at the BBC website for Stoke</text>
				</relatedpromo>
			</team>
			<team fullname="Stenhousemuir" dropdownname="Stenhousemuir">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Stevenage Borough" dropdownname="Stevenage">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="Stirling Albion" dropdownname="Stirling">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Stockport County" dropdownname="Stockport">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Stoke City" dropdownname="Stoke">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/stoke/sport/index.shtml</url>
					<image>stoke</image>
					<text>More on this team at the BBC website for Stoke</text>
				</relatedpromo>
			</team>
			<team fullname="Stranraer" dropdownname="Stranraer">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Sunderland" dropdownname="Sunderland">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/wear/sport/index.shtml</url>
					<image>wear</image>
					<text>More on this team at the BBC website for Wear</text>
				</relatedpromo>
			</team>
			<team fullname="Swansea City" dropdownname="Swansea">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/sport/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Swindon Town" dropdownname="Swindon">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/wiltshire/sport/index.shtml</url>
					<image>wiltshire</image>
					<text>More on this team at the BBC website for Wiltshire</text>
				</relatedpromo>
			</team>
			<team fullname="Tamworth" dropdownname="Tamworth">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/stoke/sport/index.shtml</url>
					<image>stoke</image>
					<text>More on this team at the BBC website for Stoke</text>
				</relatedpromo>
			</team>
			<team fullname="Torquay United" dropdownname="Torquay">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/devon/sport/index.shtml</url>
					<image>devon</image>
					<text>More on this team at the BBC website for Devon</text>
				</relatedpromo>
			</team>
			<team fullname="Tottenham Hotspur" dropdownname="Tottenham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Tranmere Rovers" dropdownname="Tranmere">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/liverpool/sport/index.shtml</url>
					<image>liverpool</image>
					<text>More on this team at the BBC website for Liverpool</text>
				</relatedpromo>
			</team>
			<team fullname="Wales" dropdownname="Wales">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/sport/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Walsall" dropdownname="Walsall">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/blackcountry/sport/index.shtml</url>
					<image>blackcountry</image>
					<text>More on this team at the BBC website for The Black County</text>
				</relatedpromo>
			</team>
			<team fullname="Watford" dropdownname="Watford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="West Bromwich Albion" dropdownname="West Brom">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/blackcountry/sport/index.shtml</url>
					<image>blackcountry</image>
					<text>More on this team at the BBC website for The Black County</text>
				</relatedpromo>
			</team>
			<team fullname="West Ham United" dropdownname="West Ham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Weymouth" dropdownname="Weymouth">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/dorset/sport/index.shtml</url>
					<image>dorset</image>
					<text>More on this team at the BBC website for Dorset</text>
				</relatedpromo>
			</team>
			<team fullname="Wigan Athletic" dropdownname="Wigan">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Woking" dropdownname="Woking">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="Wolverhampton Wanderers" dropdownname="Wolverhampton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/blackcountry/sport/index.shtml</url>
					<image>blackcountry</image>
					<text>More on this team at the BBC website for The Black County</text>
				</relatedpromo>
			</team>
			<team fullname="Wrexham" dropdownname="Wrexham">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/sport/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Wycombe Wanderers" dropdownname="Wycombe">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="Yeovil Town" dropdownname="Yeovil">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/somerset/sport/index.shtml</url>
					<image>somerset</image>
					<text>More on this team at the BBC website for Somerset</text>
				</relatedpromo>
			</team>
			<team fullname="York City" dropdownname="York">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/northyorkshire/sport/index.shtml</url>
					<image>northyorkshire</image>
					<text>More on this team at the BBC website for North Yorkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Otherteam" dropdownname="Other">
			</team>
		</sport>
		<!-- CRICKET -->
		<sport type="Cricket">
			<team fullname="Australia" dropdownname="Australia">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/australia/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest Australia cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Bangladesh" dropdownname="Bangladesh">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/bangladesh/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest Bangladesh cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Derbyshire" dropdownname="Derbyshire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/derby/sport/index.shtml</url>
					<image>derby</image>
					<text>More on this team at the BBC website for Derby</text>
				</relatedpromo>
			</team>
			<team fullname="Durham" dropdownname="Durham">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/wear/sport/index.shtml</url>
					<image>wear</image>
					<text>More on this team at the BBC website for Wear</text>
				</relatedpromo>
			</team>
			<team fullname="England" dropdownname="England">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/england/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest England cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Essex" dropdownname="Essex">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/essex/sport/index.shtml</url>
					<image>essex</image>
					<text>More on this team at the BBC website for Essex</text>
				</relatedpromo>
			</team>
			<team fullname="Glamorgan" dropdownname="Glamorgan">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/sport/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Gloucestershire" dropdownname="Gloucestershire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/gloucestershire/sport/index.shtml</url>
					<image>gloucestershire</image>
					<text>More on this team at the BBC website for Gloucestershire</text>
				</relatedpromo>
			</team>
			<team fullname="Hampshire" dropdownname="Hampshire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/hampshire/sport/index.shtml</url>
					<image>hampshire</image>
					<text>More on this team at the BBC website for Hampshire</text>
				</relatedpromo>
			</team>
			<team fullname="India" dropdownname="India">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/india/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest India cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Ireland" dropdownname="Ireland">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Kent" dropdownname="Kent">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/kent/sport/index.shtml</url>
					<image>kent</image>
					<text>More on this team at the BBC website for Kent</text>
				</relatedpromo>
			</team>
			<team fullname="Lancashire" dropdownname="Lancashire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/lancashire/sport/index.shtml</url>
					<image>lancashire</image>
					<text>More on this team at the BBC website for Lancashire</text>
				</relatedpromo>
			</team>
			<team fullname="Leicestershire" dropdownname="Leicestershire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/leicester/sport/index.shtml</url>
					<image>leicester</image>
					<text>More on this team at the BBC website for Leicester</text>
				</relatedpromo>
			</team>
			<team fullname="Middlesex" dropdownname="Middlesex">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="New Zealand" dropdownname="New Zealand">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/new_zealand/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest New Zealand cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Northants" dropdownname="Northants">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/northamptonshire/sport/index.shtml</url>
					<image>northamptonshire</image>
					<text>More on this team at the BBC website for Northamptonshire</text>
				</relatedpromo>
			</team>
			<team fullname="Nottinghamshire" dropdownname="Nottinghamshire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/nottingham/sport/index.shtml</url>
					<image>nottingham</image>
					<text>More on this team at the BBC website for Nottingham</text>
				</relatedpromo>
			</team>
			<team fullname="Pakistan" dropdownname="Pakistan">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/pakistan/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest Pakistan cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Scotland" dropdownname="Scotland">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Somerset" dropdownname="Somerset">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/somerset/sport/index.shtml</url>
					<image>somerset</image>
					<text>More on this team at the BBC website for Somerset</text>
				</relatedpromo>
			</team>
			<team fullname="South Africa" dropdownname="South Africa">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/south_africa/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest South Africa cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Sri Lanka" dropdownname="Sri Lanka">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/sri_lanka/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest Sri Lanka cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Surrey" dropdownname="Surrey">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="Sussex" dropdownname="Sussex">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="Warwickshire" dropdownname="Warwickshire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/southerncounties/sport/index.shtml</url>
					<image>southerncounties</image>
					<text>More on this team at the BBC website for Surrey and Sussex</text>
				</relatedpromo>
			</team>
			<team fullname="West Indies" dropdownname="West Indies">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/west_indies/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest West Indies cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Worcestershire" dropdownname="Worcestershire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/herefordandworcester/sport/index.shtml</url>
					<image>herefordandworcester</image>
					<text>More on this team at the BBC website for Hereford &amp; Worcester</text>
				</relatedpromo>
			</team>
			<team fullname="Yorkshire" dropdownname="Yorkshire">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/leeds/sport/index.shtml</url>
					<image>leeds</image>
					<text>More on this team at the BBC website for Leeds</text>
				</relatedpromo>
			</team>
			<team fullname="Zimbabwe" dropdownname="Zimbabwe">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/other_international/zimbabwe/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest Zimbabwe cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Otherteam" dropdownname="Other">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/cricket/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest cricket news on the BBC Sport website</text>
				</relatedpromo>
			</team>
		</sport>
		<!-- RUGBY UNION -->
		<sport type="Rugby union">
			<team fullname="Australia" dropdownname="Australia">
				<relatedpromo type="BBC Sport Rugby Union">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/international/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest international rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Bath" dropdownname="Bath">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/somerset/sport/index.shtml</url>
					<image>somerset</image>
					<text>More on this team at the BBC website for Somerset</text>
				</relatedpromo>
			</team>
			<team fullname="Borders" dropdownname="Borders">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Bristol" dropdownname="Bristol">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bristol/sport/index.shtml</url>
					<image>bristol</image>
					<text>More on this team at the BBC website for Bristol</text>
				</relatedpromo>
			</team>
			<team fullname="Cardiff Blues" dropdownname="Cardiff Blues">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/scrumv/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Connacht" dropdownname="Connacht">
				<relatedpromo type="BBC Northern Ireland">
					<url>http://www.bbc.co.uk/northernireland/</url>
					<image>northernireland</image>
					<text>Find the latest Northern Ireland sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Edinburgh" dropdownname="Edinburgh">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="England" dropdownname="England">
				<relatedpromo type="BBC Sport Rugby Union">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/english/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest England rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="France" dropdownname="France">
				<relatedpromo type="BBC Sport Rugby Union">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/international/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest international rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Glasgow" dropdownname="Glasgow">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="Gloucester" dropdownname="Gloucester">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/gloucestershire/sport/index.shtml</url>
					<image>gloucestershire</image>
					<text>More on this team at the BBC website for Gloucestershire</text>
				</relatedpromo>
			</team>
			<team fullname="Harlequins" dropdownname="Harlequins">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Ireland" dropdownname="Ireland">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/irish/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest Ireland rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Italy" dropdownname="Italy">
				<relatedpromo type="BBC Sport Rugby Union">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/international/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest international rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Leicester" dropdownname="Leicester">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/leicester/sport/index.shtml</url>
					<image>leicester</image>
					<text>More on this team at the BBC website for Leicester</text>
				</relatedpromo>
			</team>
			<team fullname="Leinster" dropdownname="Leinster">
				<relatedpromo type="BBC Northern Ireland">
					<url>http://www.bbc.co.uk/northernireland/</url>
					<image>northernireland</image>
					<text>Find the latest Northern Ireland sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Scarlets" dropdownname="Scarlets">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/scrumv/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="London Irish" dropdownname="London Irish">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/berkshire/sport/index.shtml</url>
					<image>berkshire</image>
					<text>More on this team at the BBC website for Berkshire</text>
				</relatedpromo>
			</team>
			<team fullname="Munster" dropdownname="Munster">
				<relatedpromo type="BBC Northern Ireland">
					<url>http://www.bbc.co.uk/northernireland/</url>
					<image>northernireland</image>
					<text>Find the latest Northern Ireland sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="New Zealand" dropdownname="New Zealand">
				<relatedpromo type="BBC Sport Rugby Union">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/international/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest international rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Newcastle" dropdownname="Newcastle">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/tyne/sport/index.shtml</url>
					<image>tyne</image>
					<text>More on this team at the BBC website for Tyne</text>
				</relatedpromo>
			</team>
			<team fullname="Newport-Gwent Dragons" dropdownname="Newport-Gwent D'gons">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/scrumv/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Northampton" dropdownname="Northampton">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/northamptonshire/sport/index.shtml</url>
					<image>northamptonshire</image>
					<text>More on this team at the BBC website for Northamptonshire</text>
				</relatedpromo>
			</team>
			<team fullname="Ospreys" dropdownname="Ospreys">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/scrumv/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Sale" dropdownname="Sale">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Saracens" dropdownname="Saracens">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="Scotland" dropdownname="Scotland">
				<relatedpromo type="BBC Scotland Sport">
					<url>http://www.bbc.co.uk/scotland/sportscotland/</url>
					<image>bbcsport_scotland</image>
					<text>More on this team at BBC Scotland Sport</text>
				</relatedpromo>
			</team>
			<team fullname="South Africa" dropdownname="South Africa">
				<relatedpromo type="BBC Sport Rugby Union">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/international/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest international rugby news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Ulster" dropdownname="Ulster">
				<relatedpromo type="BBC Northern Ireland">
					<url>http://www.bbc.co.uk/northernireland/</url>
					<image>northernireland</image>
					<text>Find the latest Northern Ireland sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Wales" dropdownname="Wales">
				<relatedpromo type="BBC Wales Sport">
					<url>http://www.bbc.co.uk/wales/scrumv/</url>
					<image>bbcsport_wales</image>
					<text>Find the latest Welsh sports news on your local BBC site</text>
				</relatedpromo>
			</team>
			<team fullname="Wasps" dropdownname="Wasps">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/threecounties/sport/index.shtml</url>
					<image>threecounties</image>
					<text>More on this team at the BBC website for Beds, Herts and Bucks</text>
				</relatedpromo>
			</team>
			<team fullname="Worcester" dropdownname="Worcester">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/herefordandworcester/sport/index.shtml</url>
					<image>herefordandworcester</image>
					<text>More on this team at the BBC website for Hereford &amp; Worcester</text>
				</relatedpromo>
			</team>
			<team fullname="Otherteam" dropdownname="Other">
				<relatedpromo type="">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_union/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest rugby union news on the BBC Sport website</text>
				</relatedpromo>
			</team>
		</sport>
		<!-- RUGBY LEAGUE -->
		<sport type="Rugby league">
			<team fullname="Australia" dropdownname="Australia">
				<relatedpromo type="BBC Sport Rugby League">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_league/international_and_australian/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest rugby league news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Bradford" dropdownname="Bradford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Castleford" dropdownname="Castleford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Catalans Dragons" dropdownname="Catalans Dragons">
				<relatedpromo type="BBC Sport Rugby League">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_league/super_league/catalan/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest rugby league news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Great Britain" dropdownname="Great Britain">
				<relatedpromo type="BBC Sport Rugby League">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_league/international_and_australian/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest rugby league news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Harlequins Rugby League" dropdownname="Harlequins RL">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/london/sport/index.shtml</url>
					<image>london</image>
					<text>More on this team at the BBC website for London</text>
				</relatedpromo>
			</team>
			<team fullname="Huddersfield" dropdownname="Huddersfield">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Hull" dropdownname="Hull">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/humber/sport/index.shtml</url>
					<image>humber</image>
					<text>More on this team at the BBC website for Humberside</text>
				</relatedpromo>
			</team>
			<team fullname="Leeds" dropdownname="Leeds">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/leeds/sport/index.shtml</url>
					<image>leeds</image>
					<text>More on this team at the BBC website for Leeds</text>
				</relatedpromo>
			</team>
			<team fullname="New Zealand" dropdownname="New Zealand">
				<relatedpromo type="BBC Sport Rugby League">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_league/international_and_australian/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest rugby league news on the BBC Sport website</text>
				</relatedpromo>
			</team>
			<team fullname="Salford" dropdownname="Salford">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="St Helens" dropdownname="St Helens">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/liverpool/sport/index.shtml</url>
					<image>liverpool</image>
					<text>More on this team at the BBC website for Liverpool</text>
				</relatedpromo>
			</team>
			<team fullname="Wakefield" dropdownname="Wakefield">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/bradford/sport/index.shtml</url>
					<image>bradford</image>
					<text>More on this team at the BBC website for Bradford</text>
				</relatedpromo>
			</team>
			<team fullname="Warrington" dropdownname="Warrington">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Wigan" dropdownname="Wigan">
				<relatedpromo type="BBC Local">
					<url>http://www.bbc.co.uk/manchester/sport/index.shtml</url>
					<image>manchester</image>
					<text>More on this team at the BBC website for Manchester</text>
				</relatedpromo>
			</team>
			<team fullname="Otherteam" dropdownname="Other">
				<relatedpromo type="BBC Sport Rugby League">
					<url>http://news.bbc.co.uk/sport1/hi/rugby_league/default.stm</url>
					<image>bbcsport</image>
					<text>Find the latest rugby league news on the BBC Sport website</text>
				</relatedpromo>
			</team>
		</sport>
	</sports>
</xsl:variable>
	
	
<!--=========  Banners   =========-->
	
<!-- 
	BANNERS:
	
	Scottish football
	Welsh football
	Welsh cricket
	Welsh rugby union
	
	Irish football
	Scottish cricket
	Irish cricket
	Scottish rugby union
	Irish rugby union
	Irish gaelic games
	
	606 (default)
	
-->
<xsl:variable name="banner">
	<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH' and /H2G2/ARTICLESEARCH/PHRASES/PHRASE/NAME='scottish' and /H2G2/ARTICLESEARCH/PHRASES/PHRASE/NAME='football'">scottishfootball</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLE/GUIDE/BODY/DYNAMIC-LIST/@BANNER"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BODY/DYNAMIC-LIST/@BANNER"/></xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Football' and (msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image='bbcsport_scotland' or contains($competition,'Scottish') )">scottishfootball</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Football' and (msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image='bbcsport_wales' or $competition='Welsh')">welshfootball</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Cricket' and $team='Glamorgan'">welshcricket</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Rugby union' and (msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image='bbcsport_wales' or $competition='Welsh')">welshrugbyunion</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Football' and ( contains($team,'Ireland') or $competition='Irish' )">irishfootball</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Cricket' and $team='Scotland'">scottishcricket</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Cricket' and $team='Ireland'">irishcricket</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Rugby union' and (msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image='bbcsport_scotland' or $competition='Scottish club rugby' )">scottishrugbyunion</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and $sport='Rugby union' and (msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image='northernireland' or $team='Ireland' or $competition='Irish club rugby' )">irishrugbyunion</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLE/GUIDE/OTHERSPORT='Gaelic games'">irishgaelicgames</xsl:when>
		<xsl:otherwise>606</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	
</xsl:stylesheet>
