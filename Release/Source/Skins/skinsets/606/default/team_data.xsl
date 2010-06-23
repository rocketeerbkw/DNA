<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--===============   COMPETITIONS AND TEAMS   =====================-->
	
	<!-- 
		these full names need to match the $node in the drop downs 
	
		todo: could drop downs be generated as a variable rather than hard coded - would need text for options e.g optionname="QPR"
	-->
	<xsl:variable name="competitions">
		<competition sport="Football" converted="football" name="Premier League" phrase="Premier League" searchterms="EPL Premiership" link="http://news.bbc.co.uk/sport1/hi/football/eng_prem/default.stm">
			<team fullname="Arsenal" phrase="Arsenal" searchterms="Gunners" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/arsenal/default.stm"/>
			<team fullname="Aston Villa" phrase="Aston Villa" searchterms="Villans Villains" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/aston_villa/default.stm"/>
			<team fullname="Birmingham City" phrase="Birmingham City" searchterms="Blues" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/birmingham_city/default.stm"/>
                        <team fullname="Blackburn Rovers" phrase="Blackburn Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/blackburn_rovers/default.stm"/>
			<team fullname="Blackpool" phrase="Blackpool" searchterms="Tangerines" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/blackpool/default.stm"/>
                        <team fullname="Bolton Wanderers" phrase="Bolton Wanderers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bolton_wanderers/default.stm"/>
		        <team fullname="Chelsea" phrase="Chelsea" searchterms="Blues" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/chelsea/default.stm"/>
			<team fullname="Everton" phrase="Everton" searchterms="Toffees" link="http://news.bbc.co.uk/sport1/hi/football/teams/e/everton/default.stm"/>
			<team fullname="Fulham" phrase="Fulham" searchterms="Cottagers" link="http://news.bbc.co.uk/sport1/hi/football/teams/f/fulham/default.stm"/>
			<team fullname="Liverpool" phrase="Liverpool" searchterms="Reds" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/liverpool/default.stm"/>
			<team fullname="Manchester City" phrase="Manchester City" searchterms="Man" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/man_city/default.stm"/>
			<team fullname="Manchester United" phrase="Manchester United" searchterms="Man Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/man_utd/default.stm"/>
			<team fullname="Newcastle United" phrase="Newcastle United" searchterms="Toon Geordies" link="http://news.bbc.co.uk/sport1/hi/football/teams/n/newcastle_united/default.stm"/>
			<team fullname="Stoke City" phrase="Stoke City" searchterms="Stoke" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/stoke_city/default.stm"/>
			<team fullname="Sunderland" phrase="Sunderland" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/sunderland/default.stm"/>
			<team fullname="Tottenham Hotspur" phrase="Tottenham Hotspur" searchterms="Spurs" link="http://news.bbc.co.uk/sport1/hi/football/teams/t/tottenham_hotspur/default.stm"/>
			<team fullname="West Bromwich Albion" phrase="West Bromwich Albion" searchterms="Brom" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/west_bromwich_albion/default.stm"/>
                        <team fullname="West Ham United" phrase="West Ham United" searchterms="Hammers Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/west_ham_utd/default.stm"/>
			<team fullname="Wigan Athletic" phrase="Wigan Athletic" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/wigan_athletic/default.stm"/>
                        <team fullname="Wolverhampton Wanderers" phrase="Wolverhampton Wanderers" searchterms="Wolves" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/wolverhampton_wanderers/default.stm"/>
		</competition>
		<competition sport="Football" converted="football" name="Championship" phrase="Championship" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/eng_div_1/default.stm">
			<team fullname="Barnsley" phrase="Barnsley" searchterms="Tykes" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/barnsley/default.stm"/>
			<team fullname="Bristol City" phrase="Bristol City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bristol_city/default.stm"/>
			<team fullname="Burnley" phrase="Burnley" searchterms="Clarets" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/burnley/default.stm"/>
                        <team fullname="Cardiff City" phrase="Cardiff City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/cardiff_city/default.stm"/>
			<team fullname="Coventry City" phrase="Coventry City" searchterms="Sky Blues" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/coventry_city/default.stm"/>
			<team fullname="Crystal Palace" phrase="Crystal Palace" searchterms="Eagles" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/crystal_palace/default.stm"/>
			<team fullname="Derby County" phrase="Derby County" searchterms="Rams" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/derby_county/default.stm"/>
                        <team fullname="Doncaster Rovers" phrase="Doncaster Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/doncaster/default.stm"/>
                        <team fullname="Hull City" phrase="Hull City" searchterms="Tigers" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/hull_city/default.stm"/>
                        <team fullname="Ipswich Town" phrase="Ipswich Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/i/ipswich_town/default.stm"/>
			<team fullname="Leeds United" phrase="Leeds United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/leeds_united/default.stm"/>
                        <team fullname="Leicester City" phrase="Leicester City" searchterms="Foxes" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/leicester_city/default.stm"/>
                        <team fullname="Middlesbrough" phrase="Middlesbrough" searchterms="Boro" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/middlesbrough/default.stm"/>
                        <team fullname="Millwall" phrase="Millwall" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/millwall/default.stm"/>
                        <team fullname="Norwich City" phrase="Norwich City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/n/norwich/default.stm"/>
                        <team fullname="Nottingham Forest" phrase="Nottingham Forest" searchterms="Nottm" link="http://news.bbc.co.uk/sport1/hi/football/teams/n/nottm_forest/default.stm"/>
                        <team fullname="Portsmouth" phrase="Portsmouth" searchterms="Pompey" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/portsmouth/default.stm"/>
                        <team fullname="Preston North End" phrase="Preston North End" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/preston/default.stm"/>
			<team fullname="QPR" phrase="QPR" searchterms="Hoops Rs" link="http://news.bbc.co.uk/sport1/hi/football/teams/q/qpr/default.stm"/> <!--Queen's -->
			<team fullname="Reading" phrase="Reading" searchterms="Royals" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/reading/default.stm"/>
                        <team fullname="Scunthorpe United" phrase="Scunthorpe United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/scunthorpe_utd/default.stm"/>
                        <team fullname="Sheffield United" phrase="Sheffield United" searchterms="Blades Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/sheff_utd/default.stm"/>
                        <team fullname="Swansea City" phrase="Swansea City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/swansea_city/default.stm"/>
                        <team fullname="Watford" phrase="Watford" searchterms="Hornets" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/watford/default.stm"/>
			
		</competition>
		<competition sport="Football" converted="football" name="League One" phrase="League One" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/eng_div_2/default.stm">
			<team fullname="Bournemouth" phrase="Bournemouth" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bournemouth/default.stm"/>
                        <team fullname="Brentford" phrase="Brentford" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/brentford/default.stm"/>
			<team fullname="Brighton and Hove Albion" phrase="Brighton and Hove Albion" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/brighton/default.stm"/>
			<team fullname="Bristol Rovers" phrase="Bristol Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bristol_rovers/default.stm"/>
			<team fullname="Carlisle United" phrase="Carlisle United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/carlisle_united/default.stm"/>
			<team fullname="Charlton Athletic" phrase="Charlton Athletic" searchterms="Addicks" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/charlton_athletic/default.stm"/>
                        <team fullname="Colchester United" phrase="Colchester United" searchterms="Col Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/colchester_united/default.stm"/>
                        <team fullname="Dagenham and Redbridge" phrase="Dagenham and Redbridge" searchterms="Dag Red" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/dagenham_and_redbridge/default.stm"/>
                        <team fullname="Exeter City" phrase="Exeter City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/e/exeter_city/default.stm"/>
                        <team fullname="Hartlepool United" phrase="Hartlepool United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/hartlepool_united/default.stm"/>
			<team fullname="Huddersfield Town" phrase="Huddersfield Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/huddersfield_town/default.stm"/>
			<team fullname="Leyton Orient" phrase="Leyton Orient" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/leyton_orient/default.stm"/>
			<team fullname="Milton Keynes Dons" phrase="Milton Keynes Dons" searchterms="MK" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/wimbledon/default.stm"/>
                        <team fullname="Notts County" phrase="Notts County" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/n/notts_county/default.stm"/>
                        <team fullname="Oldham Athletic" phrase="Oldham Athletic" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/o/oldham_athletic/default.stm"/>
			<team fullname="Peterborough United" phrase="Peterborough United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/peterborough_united/default.stm"/>
                        <team fullname="Plymouth Argyle" phrase="Plymouth Argyle" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/plymouth_argyle/default.stm"/>
                        <team fullname="Rochdale" phrase="Rochdale" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/rochdale/default.stm"/>
                        <team fullname="Sheffield Wednesday" phrase="Sheffield Wednesday" searchterms="Owls Weds Sheff Wed" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/sheff_wed/default.stm"/>
                        <team fullname="Southampton" phrase="Southampton" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/southampton/default.stm"/>
                        <team fullname="Swindon Town" phrase="Swindon Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/swindon_town/default.stm"/>
			<team fullname="Tranmere Rovers" phrase="Tranmere Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/t/tranmere_rovers/default.stm"/>
			<team fullname="Walsall" phrase="Walsall" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/t/torquay_united/default.stm"/>
			
                        <team fullname="Yeovil Town" phrase="Yeovil Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/y/yeovil/default.stm"/>
		</competition>
		<competition sport="Football" converted="football" name="League Two" phrase="League Two" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/eng_div_3/default.stm">
			<team fullname="Accrington Stanley" phrase="Accrington Stanley" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/accrington_stanley/default.stm"/>
			<team fullname="Aldershot Town" phrase="Aldershot Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/aldershot/default.stm"/>
                        <team fullname="Barnet" phrase="Barnet" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/barnet/default.stm"/>
			<team fullname="Bradford City" phrase="Bradford City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bradford_city/default.stm"/>
			<team fullname="Burton Albion" phrase="Burton Albion" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/burton_albion/default.stm"/>
                        <team fullname="Bury" phrase="Bury" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bury/default.stm"/>
			<team fullname="Cheltenham Town" phrase="Cheltenham Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/cheltenham_town/default.stm"/>
                        <team fullname="Chesterfield" phrase="Chesterfield" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/chesterfield/default.stm"/>
			<team fullname="Crewe Alexandra" phrase="Crewe Alexandra" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/crewe_alexandra/default.stm"/>
                        <team fullname="Gillingham" phrase="Gillingham" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/g/gillingham/default.stm"/>
                        <team fullname="Hereford United" phrase="Hereford United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/hereford_united/default.stm"/>
                        <team fullname="Lincoln City" phrase="Lincoln City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/lincoln_city/default.stm"/>
			<team fullname="Macclesfield Town" phrase="Macclesfield Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/macclesfield_town/default.stm"/>
			<team fullname="Morecambe" phrase="Morecambe" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/morecambe/default.stm"/>
			<team fullname="Northampton Town" phrase="Northampton Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/n/northampton_town/default.stm"/>
                        <team fullname="Oxford United" phrase="Oxford United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/o/oxford_utd/default.stm"/>
			<team fullname="Port Vale" phrase="Port Vale" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/port_vale/default.stm"/>
                        <team fullname="Rotherham United" phrase="Rotherham United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/rotherham_utd/default.stm"/>
			<team fullname="Shrewsbury Town" phrase="Shrewsbury Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/shrewsbury/default.stm"/>
			<team fullname="Southend United" phrase="Southend United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/southend_utd/default.stm"/>
                        <team fullname="Stevenage" phrase="Stevenage" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/stevenage/default.stm"/>
                        <team fullname="Stockport County" phrase="Stockport County" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/stockport/default.stm"/>
                        <team fullname="Torquay United" phrase="Torquay United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/t/torquay_united/default.stm"/>
			<team fullname="Wycombe Wanderers" phrase="Wycombe Wanderers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/wycombe_wanderers/default.stm"/>
                </competition>
		<competition sport="Football" converted="football" name="Non League" phrase="Non League" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/eng_conf/default.stm">
			<team fullname="AFC Wimbledon" phrase="AFC Wimbledon" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/afc_wimbledon/default.stm"/>
                        <team fullname="Altrincham" phrase="Altrincham" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/altrincham/default.stm"/>
			<team fullname="Barrow" phrase="Barrow" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/barrow/default.stm"/>
                        <team fullname="Bath City" phrase="Bath City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/bath_city/default.stm"/>			                   
                        <team fullname="Cambridge United" phrase="Cambridge United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/cambridge_utd/default.stm"/>
			<team fullname="Crawley Town" phrase="Crawley Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/crawley_town/default.stm"/>
			<team fullname="Darlington" phrase="Darlington" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/darlington/default.stm"/>			                   
                        <team fullname="Eastbourne Borough" phrase="Eastbourne Borough" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/e/eastbourne_borough/default.stm"/>
                        <team fullname="Fleetwood Town" phrase="Fleetwood Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/f/fleetwood_town/default.stm"/>
                        <team fullname="Forest Green Rovers" phrase="Forest Green Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/f/forest_green_rovers/default.stm"/>
			<team fullname="Gateshead" phrase="Gateshead" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/g/gateshead/default.stm"/>
                        <team fullname="Grimsby Town" phrase="Grimsby Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/g/grimsby_town/default.stm"/>
                        <team fullname="Hayes and Yeading United" phrase="Hayes and Yeading United" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/hayes_and_yeading/default.stm"/>
                        <team fullname="Histon" phrase="Histon" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/histon/default.stm"/>
			<team fullname="Kettering Town" phrase="Kettering Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/k/kettering_town/default.stm"/>
                        <team fullname="Kidderminster Harriers" phrase="Kidderminster Harriers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/k/kidderminster_harriers/default.stm"/>
			<team fullname="Luton Town" phrase="Luton Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/luton_town/default.stm"/>
                        <team fullname="Mansfield Town" phrase="Mansfield Town" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/mansfield_town/default.stm"/>
                        <team fullname="Newport County" phrase="Newport County" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/n/newport_county/default.stm"/>
			<team fullname="Rushden and Diamonds" phrase="Rushden and Diamonds" searchterms="Dmonds" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/rushden_and_diamonds/default.stm"/>
			<team fullname="Southport" phrase="Southport" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/southport/default.stm"/>
			<team fullname="Tamworth" phrase="Tamworth" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/t/tamworth/default.stm"/>
			<team fullname="Wrexham" phrase="Wrexham" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/w/wrexham/default.stm"/>
                        <team fullname="York City" phrase="York City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/y/york_city/default.stm"/>
		</competition>
		<competition sport="Football" converted="football" name="Scottish Premier" phrase="Scottish Premier" searchterms="SPL" link="http://news.bbc.co.uk/sport1/hi/football/scot_prem/default.stm">
			<team fullname="Aberdeen" phrase="Aberdeen" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/aberdeen/default.stm"/>
			<team fullname="Celtic" phrase="Celtic" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/celtic/default.stm"/>
			<team fullname="Dun Utd" phrase="Dun Utd" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/dundee_utd/default.stm"/>
			<team fullname="Hamilton Academical" phrase="Hamilton Academical" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/hamilton_academical/default.stm"/>
			<team fullname="Heart of Midlothian" phrase="Heart of Midlothian" searchterms="Hearts" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/heart_of_midlothian/default.stm"/>
			<team fullname="Hibernian" phrase="Hibernian" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/h/hibernian/default.stm"/>
			<team fullname="Inverness Caledonian Thistle" phrase="Inverness Caledonian Thistle" searchterms="CT" link="http://news.bbc.co.uk/sport1/hi/football/teams/i/inverness_ct/default.stm"/>
                        <team fullname="Kilmarnock" phrase="Kilmarnock" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/k/kilmarnock/default.stm"/>
			<team fullname="Motherwell" phrase="Motherwell" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/motherwell/default.stm"/>
			<team fullname="Rangers" phrase="Rangers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/rangers/default.stm"/>
			<team fullname="St Johnstone" phrase="St Johnstone" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/st_johnstone/default.stm"/>
                        <team fullname="St Mirren" phrase="St Mirren" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/st_mirren/default.stm"/>
		</competition>
		<competition sport="Football" converted="football" name="Scottish League" phrase="Scottish League" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/scot_div_1/default.stm">
			<team fullname="Airdrie United" phrase="Airdrie United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/airdrie_united/default.stm"/>
			<team fullname="Albion Rovers" phrase="Albion Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/albion_rovers/default.stm"/>
                        <team fullname="Alloa Athletic" phrase="Alloa Athletic" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/alloa/default.stm"/>
                        <team fullname="Annan Athletic" phrase="Annan Athletic" searchterms="" link=""/>
                        <team fullname="Arbroath" phrase="Arbroath" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/arbroath/default.stm"/>
                        <team fullname="Ayr United" phrase="Ayr United" searchterms="Utd" link="http://news.bbc.co.uk/sport1/hi/football/teams/a/ayr_united/default.stm"/>
                        <team fullname="Berwick Rangers" phrase="Berwick Rangers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/berwick_rangers/default.stm"/>
                        <team fullname="Brechin City" phrase="Brechin City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/b/brechin_city/default.stm"/>
                        <team fullname="Clyde" phrase="Clyde" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/clyde/default.stm"/>
			<team fullname="Cowdenbeath" phrase="Cowdenbeath" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/c/cowdenbeath/default.stm"/>
                        <team fullname="Dumbarton" phrase="Dumbarton" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/dumbarton/default.stm"/>
                        <team fullname="Dundee" phrase="Dundee" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/dundee/default.stm"/>
                        <team fullname="Dunfermline Athletic" phrase="Dunfermline Athletic" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/d/dunfermline_athletic/default.stm"/>
			<team fullname="East Fife" phrase="East Fife" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/e/east_fife/default.stm"/>
			<team fullname="East Stirlingshire" phrase="East Stirlingshire" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/e/east_stirlingshire/default.stm"/>
			<team fullname="Elgin City" phrase="Elgin City" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/e/elgin_city/default.stm"/>
                        <team fullname="Falkirk" phrase="Falkirk" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/f/falkirk/default.stm"/>
                        <team fullname="Forfar Athletic" phrase="Forfar Athletic" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/f/forfar_athletic/default.stm"/>
                        <team fullname="Livingston" phrase="Livingston" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/l/livingston/default.stm"/>
			<team fullname="Montrose" phrase="Montrose" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/montrose/default.stm"/>
                        <team fullname="Morton" phrase="Morton" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/m/morton/default.stm"/>
                        <team fullname="Partick Thistle" phrase="Partick Thistle" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/partick_thistle/default.stm"/>
			<team fullname="Peterhead" phrase="Peterhead" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/p/peterhead/default.stm"/>
                        <team fullname="Queen of the South" phrase="Queen of the South" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/q/queen_of_the_south/default.stm"/>
                        <team fullname="Queens Park" phrase="Queens Park" searchterms="Queen%27s" link="http://news.bbc.co.uk/sport1/hi/football/teams/q/queens_park/default.stm"/>
                        <team fullname="Raith Rovers" phrase="Raith Rovers" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/raith_rovers/default.stm"/>
                        <team fullname="Ross County" phrase="Ross County" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/r/ross_county/default.stm"/>
			<team fullname="Stenhousemuir" phrase="Stenhousemuir" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/stenhousemuir/default.stm"/>
			<team fullname="Stirling Albion" phrase="Stirling Albion" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/stirling_albion/default.stm"/>
			<team fullname="Stranraer" phrase="Stranraer" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/teams/s/stranraer/default.stm"/>
                </competition>
		<competition sport="Football" converted="football" name="International" phrase="International" searchterms="" link="http://news.bbc.co.uk/sport1/hi/football/internationals/default.stm" hidefromteam="yes">
			<team fullname="England" phrase="England" searchterms="" link=""/>
			<team fullname="Northern Ireland" phrase="Northern Ireland" searchterms="" link=""/>
			<team fullname="Republic of Ireland" phrase="Republic of Ireland" searchterms="" link=""/>
			<team fullname="Scotland" phrase="Scotland" searchterms="" link=""/>
			<team fullname="Wales" phrase="Wales" searchterms="" link=""/>
		</competition>
		<competition sport="Football" converted="football" name="European Football" phrase="European Football" searchterms="" link="" hidefromteam="yes">
			<team fullname="Champions League" phrase="Champions League" searchterms="" link=""/>
			<team fullname="Europa League" phrase="Europa League" searchterms="" link=""/>
                </competition>
		<competition sport="Football" converted="football" name="Women's Football" phrase="Womens Football" searchterms="" link="" hidefromteam="yes">
			<team fullname="Women's World Cup" phrase="Womens World Cup" searchterms="" link=""/>
		</competition>
		<competition name="More Non League Clubs" phrase="More Non League Clubs" sport="Football" converted="football" hide="yes">
			<team fullname="AFC Telford" phrase="AFC Telford" searchterms="" link=""/>
			<team fullname="Alfreton Town" phrase="Alfreton Town" searchterms="" link=""/>
			<team fullname="Basingstoke Town" phrase="Basingstoke" searchterms="" link=""/>
			<team fullname="Bishop's Stortford" phrase="Bishops Stortford" searchterms="" link=""/>
			<team fullname="Blyth Spartans" phrase="Blyth Spartans" searchterms="" link=""/>
			<team fullname="Boreham Wood" phrase="Boreham Wood" searchterms="" link=""/>
                        <team fullname="Boston United" phrase="Boston United" searchterms="" link=""/>
                        <team fullname="Braintree Town" phrase="Braintree Town" searchterms="" link=""/>
                        <team fullname="Bromley" phrase="Bromley" searchterms="" link=""/>
                        <team fullname="Chelmsford City" phrase="Chelmsford City" searchterms="" link=""/>
			<team fullname="Corby Town" phrase="Corby Town" searchterms="" link=""/>
                        <team fullname="Dartford" phrase="Dartford" searchterms="" link=""/>
                        <team fullname="Dorchester Town" phrase="Dorchester Town" searchterms="" link=""/>
			<team fullname="Dover Athletic" phrase="Dover Athletic" searchterms="" link=""/>
                        <team fullname="Droylsden" phrase="Droylsden" searchterms="" link=""/>
			<team fullname="Eastleigh" phrase="Eastleigh" searchterms="" link=""/>
			<team fullname="Eastwood Town" phrase="Eastwood Town" searchterms="" link=""/>
                        <team fullname="Ebbsfleet United" phrase="Ebbsfleet United" searchterms="" link=""/>
                        <team fullname="Farnborough" phrase="Farnborough" searchterms="" link=""/>
                        <team fullname="Gainsborough Trinity" phrase="Gainsborough Trinity" searchterms="" link=""/>
			<team fullname="Gloucester City" phrase="Gloucester City" searchterms="" link=""/>
                        <team fullname="Guiseley" phrase="Guiseley" searchterms="" link=""/>
                        <team fullname="Hampton and Richmond" phrase="Hampton and Richmond" searchterms="" link=""/>
                        <team fullname="Harrogate Town" phrase="Harrogate Town" searchterms="" link=""/>
			<team fullname="Havant and Waterlooville" phrase="Havant and Waterlooville" searchterms="" link=""/>
			<team fullname="Hinckley United" phrase="Hinckley United" searchterms="" link=""/>
			<team fullname="Hyde United" phrase="Hyde United" searchterms="" link=""/>
			<team fullname="Ilkeston Town" phrase="Ilkeston Town" searchterms="" link=""/>
			<team fullname="Lewes" phrase="Lewes" searchterms="" link=""/>
                        <team fullname="Maidenhead United" phrase="Maidenhead United" searchterms="" link=""/>			
			<team fullname="Nuneaton Town" phrase="Nuneaton Town" searchterms="" link=""/>
                        <team fullname="Redditch United" phrase="Redditch United" searchterms="" link=""/>
			<team fullname="St Albans City" phrase="St Albans City" searchterms="" link=""/>
                        <team fullname="Solihull Moors" phrase="Solihull Moors" searchterms="" link=""/>
			<team fullname="Stafford Rangers" phrase="Stafford Rangers" searchterms="" link=""/>
                        <team fullname="Staines Town" phrase="Staines Town" searchterms="" link=""/>
                        <team fullname="Stalybridge Celtic" phrase="Stalybridge Celtic" searchterms="" link=""/>
			<team fullname="Thurrock" phrase="Thurrock" searchterms="" link=""/>
			<team fullname="Vauxhall Motors" phrase="Vauxhall Motors" searchterms="" link=""/>
			<team fullname="Welling United" phrase="Welling United" searchterms="" link=""/>
			<team fullname="Weston-Super-Mare" phrase="Weston-Super-Mare" searchterms="" link=""/>
			<team fullname="Woking" phrase="Woking" searchterms="" link=""/>
                        <team fullname="Worcester City" phrase="Worcester City" searchterms="" link=""/>
			<team fullname="Workington" phrase="Workington" searchterms="" link=""/>
		</competition>
		<competition name="Welsh" phrase="Welsh" sport="Football"/>
		<competition name="Wales" phrase="Wales" sport="Football" hide="yes">
			<team fullname="Aberystwyth Town" phrase="Aberystwyth" searchterms="" link=""/>
			<team fullname="Airbus UK" phrase="Airbus UK" searchterms="" link=""/>
			<team fullname="Bala Town" phrase="Bala Town" searchterms="" link=""/>
                        <team fullname="Bangor City" phrase="Bangor City" searchterms="" link=""/>
			<team fullname="Carmarthen Town" phrase="Carmarthen" searchterms="" link=""/>
			<team fullname="Haverfordwest" phrase="Haverfordwest" searchterms="" link=""/>
			<team fullname="Llanelli" phrase="Llanelli" searchterms="" link=""/>
			<team fullname="Neath Athletic" phrase="Neath Athletic" searchterms="" link=""/>
                        <team fullname="Newtown" phrase="Newtown" searchterms="" link=""/>
			<team fullname="Port Talbot Town" phrase="Port Talbot Town" searchterms="" link=""/>
			<team fullname="Prestatyn Town" phrase="Prestatyn Town" searchterms="" link=""/>
			<team fullname="The New Saints" phrase="The New Saints" searchterms="" link=""/>
		</competition>
		<competition name="Irish" phrase="Irish" sport="Football">
			<team fullname="Bohemians" phrase="Bohemians" searchterms="" link=""/>
			<team fullname="Bray Wanderers" phrase="Bray Wanderers" searchterms="" link=""/>
			<team fullname="Derry City" phrase="Derry City" searchterms="" link=""/>
			<team fullname="Drogheda United" phrase="Drogheda United" searchterms="" link=""/>
			<team fullname="Dundalk" phrase="Dundalk" searchterms="" link=""/>
                        <team fullname="Galway United" phrase="Galway United" searchterms="" link=""/>
			<team fullname="St Patrick's Athletic" phrase="St Patrick's Athletic" searchterms="" link=""/>
                        <team fullname="Shamrock Rovers" phrase="Shamrock Rovers" searchterms="" link=""/>
			<team fullname="Sligo Rovers" phrase="Sligo Rovers" searchterms="" link=""/>
			<team fullname="Sporting Fingal" phrase="Sporting Fingal" searchterms="" link=""/>
			<team fullname="UCD" phrase="UCD" searchterms="" link=""/>
                </competition>
		<competition name="Northern Ireland" phrase="Northern Ireland" sport="Football" hide="yes">
			<team fullname="Ballymena" phrase="Ballymena" searchterms="" link=""/>
			<team fullname="Cliftonville" phrase="Cliftonville" searchterms="" link=""/>
			<team fullname="Coleraine" phrase="Coleraine" searchterms="" link=""/>
			<team fullname="Crusaders" phrase="Crusaders" searchterms="" link=""/>
			<team fullname="Donegal Celtic" phrase="Donegal Celtic" searchterms="" link=""/>
                        <team fullname="Dungannon Swifts" phrase="Dungannon Swifts" searchterms="" link=""/>
			<team fullname="Glenavon" phrase="Glenavon" searchterms="" link=""/>
			<team fullname="Glentoran" phrase="Glentoran" searchterms="" link=""/>
			<team fullname="Linfield" phrase="Linfield" searchterms="" link=""/>
			<team fullname="Lisburn Distillery" phrase="Lisburn Distillery" searchterms="" link=""/>
			<team fullname="Newry City" phrase="Newry City" searchterms="" link=""/>
                        <team fullname="Portadown" phrase="Portadown" searchterms="" link=""/>
		</competition>
		<competition name="Highland League" phrase="Highland League" sport="Football" hide="yes">
			<team fullname="Brora Rangers" phrase="Brora Rangers" searchterms="" link=""/>
			<team fullname="Buckie Thistle" phrase="Buckie Thistle" searchterms="" link=""/>
			<team fullname="Clachnacuddin" phrase="Clachnacuddin" searchterms="" link=""/>
			<team fullname="Cove Rangers" phrase="Cove Rangers" searchterms="" link=""/>
			<team fullname="Deveronvale" phrase="Deveronvale" searchterms="" link=""/>
			<team fullname="Formartine United" phrase="Formartine United" searchterms="" link=""/>
                        <team fullname="Forres Mechanics" phrase="Forres Mechanics" searchterms="" link=""/>
			<team fullname="Fort William" phrase="Fort William" searchterms="" link=""/>
			<team fullname="Fraserburgh" phrase="Fraserburgh" searchterms="" link=""/>
			<team fullname="Huntly" phrase="Huntly" searchterms="" link=""/>
			<team fullname="Inverurie Locos" phrase="Inverurie Locos" searchterms="" link=""/>
			<team fullname="Keith" phrase="Keith" searchterms="" link=""/>
			<team fullname="Lossiemouth" phrase="Lossiemouth" searchterms="" link=""/>
			<team fullname="Nairn County" phrase="Nairn County" searchterms="" link=""/>
			<team fullname="Rothes" phrase="Rothes" searchterms="" link=""/>
			<team fullname="Strathspey Thistle" phrase="Strathspey Thistle" searchterms="" link=""/>
                        <team fullname="Turriff United" phrase="Turriff United" searchterms="" link=""/>
                        <team fullname="Wick Academy" phrase="Wick Academy" searchterms="" link=""/>
		</competition>
		
		<competition name="FA Cup" phrase="FA Cup" sport="Football"/>
		<competition name="League Cup" phrase="League Cup" sport="Football"/>
		<competition name="World Cup" phrase="World Cup" sport="Football"/>
		<competition name="Euro 2012" phrase="Euro 2012" sport="Football" hidefromteam="yes"/>
                <competition name="Euro 2016" phrase="Euro 2016" sport="Football" hidefromteam="yes"/>
                <competition name="Women's World Cup" phrase="Womens World Cup" sport="Football"/>
		<competition name="African" phrase="African" sport="Football"/>
                <competition name="Africa Cup of Nations" phrase="Africa Cup of Nations" sport="Football"/>
		<competition name="Copa America" phrase="Copa America" sport="Football"/>
		<competition name="Confederations Cup" phrase="Confederations Cup" sport="Football"/>
		<competition name="Champions League" phrase="Champions League" sport="Football"/>
                <competition name="Europa League" phrase="Europa League" sport="Football"/>
		<competition name="Conference" phrase="Conference" sport="Football"/>
		<competition name="Conference North" phrase="Conference North" sport="Football"/>
		<competition name="Conference South" phrase="Conference South" sport="Football"/>
		
		<!--EUROPEAN FOOTBALL-->
		<competition name="Austrian" phrase="Austrian" sport="Football">
			<team fullname="Austria Vienna" phrase="Austria Vienna" searchterms="" link=""/>
			<team fullname="Kapfenberg" phrase="Kapfenberg" searchterms="" link=""/>
                        <team fullname="LASK Linz" phrase="LASK Linz" searchterms="" link=""/>
                        <team fullname="Mattersburg" phrase="Mattersburg" searchterms="" link=""/>
                        <team fullname="Rapid Vienna" phrase="Rapid Vienna" searchterms="" link=""/>
                        <team fullname="Ried" phrase="Ried" searchterms="" link=""/>
                        <team fullname="Salzburg" phrase="Salzburg" searchterms="" link=""/>
                        <team fullname="SK Sturm Graz" phrase="SK Sturm Graz" searchterms="" link=""/>
			<team fullname="Wacker Innsbruck" phrase="Wacker Innsbruck" searchterms="" link=""/>
                	<team fullname="Wiener Neustadt" phrase="Wiener Neustadt" searchterms="" link=""/>
                </competition>
		<competition name="Belgian" phrase="Belgian" sport="Football">
			<team fullname="Anderlecht" phrase="Anderlecht" searchterms="" link=""/>
			<team fullname="Cercle Brugge" phrase="Cercle Brugge" searchterms="" link=""/>
			<team fullname="Charleroi" phrase="Charleroi" searchterms="" link=""/>
			<team fullname="Club Brugge" phrase="Club Brugge" searchterms="" link=""/>
			<team fullname="Eupen" phrase="Eupen" searchterms="" link=""/>
                        <team fullname="Genk" phrase="Genk" searchterms="" link=""/>
			<team fullname="Gent" phrase="Gent" searchterms="" link=""/>
                        <team fullname="Germinal Beerschot" phrase="Germinal Beerschot" searchterms="" link=""/>
			<team fullname="Kortrijk" phrase="Kortrijk" searchterms="" link=""/>
			<team fullname="Lierse" phrase="Lierse" searchterms="" link=""/>
                        <team fullname="Lokeren" phrase="Lokeren" searchterms="" link=""/>
			<team fullname="Mechelen" phrase="Mechelen" searchterms="" link=""/>
			<team fullname="Sint Truiden" phrase="Sint Truiden" searchterms="" link=""/>
			<team fullname="Standard Liege" phrase="Standard Liege" searchterms="" link=""/>
			<team fullname="Westerlo" phrase="Westerlo" searchterms="" link=""/>
			<team fullname="Zulte-Waregem" phrase="Zulte-Waregem" searchterms="" link=""/>
		</competition>
		<competition name="Danish" phrase="Danish" sport="Football">
			<team fullname="AaB" phrase="AaB" searchterms="" link=""/>
			<team fullname="Brondby" phrase="Brondby" searchterms="" link=""/>
			<team fullname="Esbjerg" phrase="Esbjerg" searchterms="" link=""/>
			<team fullname="FC Copenhagen" phrase="FC Copenhagen" searchterms="" link=""/>
			<team fullname="Horsens" phrase="AC Horsens" searchterms="" link=""/>
                        <team fullname="Lyngby" phrase="Lyngby" searchterms="" link=""/>
                        <team fullname="Midtjylland" phrase="FC Midtjylland" searchterms="" link=""/>
			<team fullname="Nordsjaelland" phrase="FC Nordsjaelland" searchterms="" link=""/>
			<team fullname="Odense" phrase="Odense BK" searchterms="" link=""/>
			<team fullname="Randers" phrase="Randers FC" searchterms="" link=""/>
			<team fullname="Silkeborg" phrase="Silkeborg" searchterms="" link=""/>
                        <team fullname="Sonderjyske" phrase="Sonderjyske" searchterms="" link=""/>
		</competition>
		<competition name="Finnish" phrase="Finnish" sport="Football">
			<team fullname="Haka" phrase="FC Haka" searchterms="" link=""/>
			<team fullname="HJK Helsinki" phrase="HJK Helsinki" searchterms="" link=""/>
                        <team fullname="Honka" phrase="FC Honka" searchterms="" link=""/>
			<team fullname="Inter Turku" phrase="FC Inter" searchterms="" link=""/>
			<team fullname="Jaro" phrase="FF Jaro" searchterms="" link=""/>
			<team fullname="JJK" phrase="JJK" searchterms="" link=""/>
                        <team fullname="KuPS" phrase="KuPS Kuopio" searchterms="" link=""/>
                        <team fullname="Lahti" phrase="FC Lahti" searchterms="" link=""/>
                        <team fullname="Marienhamn" phrase="Marienhamn" searchterms="" link=""/>
			<team fullname="MyPa" phrase="MyPa" searchterms="" link=""/>
			<team fullname="Oulu" phrase="Oulu" searchterms="" link=""/>
                        <team fullname="Tampere United" phrase="Tampere United" searchterms="" link=""/>
			<team fullname="TPS" phrase="TPS" searchterms="" link=""/>
			<team fullname="VPS" phrase="VPS Vaasa" searchterms="" link=""/>
		</competition>
		<competition name="French" phrase="French" sport="Football">
			<team fullname="Arles" phrase="Arles" searchterms="" link=""/>
			<team fullname="Auxerre" phrase="Auxerre" searchterms="" link=""/>
			<team fullname="Bordeaux" phrase="Bordeaux" searchterms="" link=""/>
			<team fullname="Brest" phrase="Brest" searchterms="" link=""/>
                        <team fullname="Caen" phrase="Caen" searchterms="" link=""/>
                        <team fullname="Lens" phrase="Le Mans" searchterms="" link=""/>
			<team fullname="Lille" phrase="Lille" searchterms="" link=""/>
			<team fullname="Lorient" phrase="Lorient" searchterms="" link=""/>
			<team fullname="Lyon" phrase="Lyon" searchterms="" link=""/>
			<team fullname="Marseille" phrase="Marseille" searchterms="" link=""/>
			<team fullname="Monaco" phrase="Monaco" searchterms="" link=""/>
			<team fullname="Montpellier" phrase="Nantes" searchterms="" link=""/>
			<team fullname="Nancy" phrase="Nancy" searchterms="" link=""/>
                        <team fullname="Nice" phrase="Nice" searchterms="" link=""/>
			<team fullname="PSG" phrase="PSG" searchterms="" link=""/>
			<team fullname="Rennes" phrase="Rennes" searchterms="" link=""/>
                        <team fullname="St Etienne" phrase="St Etienne" searchterms="" link=""/>
                        <team fullname="Sochaux" phrase="Sochaux" searchterms="" link=""/>
			<team fullname="Toulouse" phrase="Toulouse" searchterms="" link=""/>
			<team fullname="Valenciennes" phrase="Valenciennes" searchterms="" link=""/>
		</competition>
		<competition name="German" phrase="German" sport="Football">
			<team fullname="Bayer Leverkusen" phrase="Bayer Leverkusen" searchterms="" link=""/>
			<team fullname="Bayern Munich" phrase="Bayern Munich" searchterms="" link=""/>
			<team fullname="Borussia Dortmund" phrase="Borussia Dortmund" searchterms="" link=""/>
			<team fullname="Borussia M'gladbach" phrase="Borussia M'gladbach" searchterms="" link=""/>
			<team fullname="Cologne" phrase="Cologne" searchterms="" link=""/>
                        <team fullname="Eintracht Frankfurt" phrase="Eintracht Frankfurt" searchterms="" link=""/>
			<team fullname="Freiburg" phrase="Freiburg" searchterms="" link=""/>
                        <team fullname="Hamburg" phrase="Hamburg" searchterms="" link=""/>
			<team fullname="Hannover 96" phrase="Hannover 96" searchterms="" link=""/>
			<team fullname="Kaiserslautern" phrase="Kaiserslautern" searchterms="" link=""/>
                        <team fullname="Mainz" phrase="Mainz" searchterms="" link=""/>
			<team fullname="Nuremberg" phrase="Nuremberg" searchterms="" link=""/>
                        <team fullname="St Pauli" phrase="St Pauli" searchterms="" link=""/>
                        <team fullname="Schalke 04" phrase="Schalke 04" searchterms="" link=""/>
                        <team fullname="TSG Hoffenheim" phrase="TSG Hoffenheim" searchterms="" link=""/>
                        <team fullname="VfB Stuttgart" phrase="VfB Stuttgart" searchterms="" link=""/>
			<team fullname="Werder Bremen" phrase="Werder Bremen" searchterms="" link=""/>
			<team fullname="Wolfsburg" phrase="Wolfsburg" searchterms="" link=""/>
		</competition>
		<competition name="Greek" phrase="Greek" sport="Football">
			<team fullname="AEK Athens" phrase="AEK Athens" searchterms="" link=""/>
			<team fullname="Aris" phrase="Aris Salonika" searchterms="" link=""/>
			<team fullname="Asteras Tripoli" phrase="Asteras Tripoli" searchterms="" link=""/>
			<team fullname="Atromitos" phrase="Atromitos" searchterms="" link=""/>
                        <team fullname="Ergotelis" phrase="Ergotelis" searchterms="" link=""/>
			<team fullname="Iraklis" phrase="Iraklis" searchterms="" link=""/>
			<team fullname="Kavala" phrase="Kavala" searchterms="" link=""/>
                        <team fullname="Kerkyra" phrase="Kerkyra" searchterms="" link=""/>
                        <team fullname="Larissa" phrase="Larissa" searchterms="" link=""/>
			<team fullname="Olympiakos" phrase="Olympiakos" searchterms="" link=""/>
			<team fullname="Olympiakos Volou" phrase="Olympiakos Volou" searchterms="" link=""/>
                        <team fullname="Panathinaikos" phrase="Panathinaikos" searchterms="" link=""/>
			<team fullname="Panionios" phrase="Panionios" searchterms="" link=""/>
			<team fullname="Panserraikos" phrase="Panserraikos" searchterms="" link=""/>
                        <team fullname="PAOK" phrase="PAOK Salonika" searchterms="" link=""/>
                        <team fullname="Skoda Xanthi" phrase="Skoda Xanthi" searchterms="" link=""/>
		</competition>
		<competition name="Netherlands" phrase="Netherlands" sport="Football">
			<team fullname="ADO Den Haag" phrase="ADO Den Haag" searchterms="" link=""/>
			<team fullname="Ajax" phrase="Ajax" searchterms="" link=""/>
			<team fullname="AZ" phrase="AZ" searchterms="" link=""/>
			<team fullname="De Graafschap" phrase="De Graafschap" searchterms="" link=""/>
			<team fullname="Excelsior" phrase="Excelsior" searchterms="" link=""/>
                        <team fullname="Feyenoord" phrase="Feyenoord" searchterms="" link=""/>
                        <team fullname="Groningen" phrase="FC Groningen" searchterms="" link=""/>
			<team fullname="Heerenveen" phrase="Heerenveen" searchterms="" link=""/>
                        <team fullname="Heracles" phrase="Heracles" searchterms="" link=""/>
                        <team fullname="NAC Breda" phrase="NAC Breda" searchterms="" link=""/>
                        <team fullname="NEC" phrase="NEC" searchterms="" link=""/>
                        <team fullname="PSV Eindhoven" phrase="PSV Eindhoven" searchterms="" link=""/>
                        <team fullname="Roda JC" phrase="Roda JC" searchterms="" link=""/>
                        <team fullname="Twente" phrase="Twente" searchterms="" link=""/>
			<team fullname="Utrecht" phrase="Utrecht" searchterms="" link=""/>
			<team fullname="VVV Venlo" phrase="VVV Venlo" searchterms="" link=""/>
                        <team fullname="Vitesse" phrase="Vitesse" searchterms="" link=""/>
			<team fullname="Willem II" phrase="Willem II" searchterms="" link=""/>
		</competition>
		<competition name="Italian" phrase="Italian" sport="Football">
			<team fullname="AC Milan" phrase="AC Milan" searchterms="" link=""/>
			<team fullname="Bari" phrase="Bari" searchterms="" link=""/>
			<team fullname="Bologna" phrase="Bologna" searchterms="" link=""/>
                        <team fullname="Brescia" phrase="Brescia" searchterms="" link=""/>
                        <team fullname="Cagliari" phrase="Cagliari" searchterms="" link=""/>
			<team fullname="Catania" phrase="Catania" searchterms="" link=""/>
			<team fullname="Cesena" phrase="Cesena" searchterms="" link=""/>
                        <team fullname="Chievo" phrase="Chievo" searchterms="" link=""/>
			<team fullname="Fiorentina" phrase="Fiorentina" searchterms="" link=""/>
			<team fullname="Genoa" phrase="Genoa" searchterms="" link=""/>
                        <team fullname="Inter Milan" phrase="Inter Milan" searchterms="" link=""/>
			<team fullname="Juventus" phrase="Juventus" searchterms="" link=""/>
			<team fullname="Lazio" phrase="Lazio" searchterms="" link=""/>
			<team fullname="Lecce" phrase="Lecce" searchterms="" link=""/>
			<team fullname="Napoli" phrase="Napoli" searchterms="" link=""/>
			<team fullname="Palermo" phrase="Palermo" searchterms="" link=""/>
			<team fullname="Parma" phrase="Parma" searchterms="" link=""/>
			<team fullname="Roma" phrase="Roma" searchterms="" link=""/>
			<team fullname="Sampdoria" phrase="Sampdoria" searchterms="" link=""/>
			<team fullname="Udinese" phrase="Udinese" searchterms="" link=""/>
		</competition>
		<competition name="Norwegian" phrase="Norwegian" sport="Football">
			<team fullname="Aalesund" phrase="Aalesund" searchterms="" link=""/>
			<team fullname="Brann" phrase="Brann" searchterms="" link=""/>
                        <team fullname="Haugesund" phrase="Haugesund" searchterms="" link=""/>
			<team fullname="Honefoss" phrase="Honefoss" searchterms="" link=""/>
                        <team fullname="Kongsvinger" phrase="Kongsvinger" searchterms="" link=""/>
			<team fullname="Lillestrom" phrase="Lillestrom" searchterms="" link=""/>
			<team fullname="Molde" phrase="Molde" searchterms="" link=""/>
			<team fullname="Odd Grenland" phrase="Odd Grenland" searchterms="" link=""/>
                        <team fullname="Rosenborg" phrase="Rosenborg" searchterms="" link=""/>
			<team fullname="Sandefjord" phrase="Sandefjord" searchterms="" link=""/>
			<team fullname="Stabaek" phrase="Stabaek" searchterms="" link=""/>
			<team fullname="Start" phrase="Start" searchterms="" link=""/>
                        <team fullname="Stromsgodset" phrase="Stromsgodset" searchterms="" link=""/>
			<team fullname="Tromso" phrase="Tromso" searchterms="" link=""/>
			<team fullname="Valerenga" phrase="Valerenga" searchterms="" link=""/>
			<team fullname="Viking" phrase="Viking" searchterms="" link=""/>
		</competition>
		<competition name="Portuguese" phrase="Portuguese" sport="Football">
			<team fullname="Academica" phrase="Academica" searchterms="" link=""/>
			<team fullname="Beira-Mar" phrase="Amadora" searchterms="" link=""/>
			<team fullname="Benfica" phrase="Benfica" searchterms="" link=""/>
			<team fullname="Braga" phrase="Braga" searchterms="" link=""/>
			<team fullname="Maritimo" phrase="Maritimo" searchterms="" link=""/>
			<team fullname="Nacional" phrase="Nacional" searchterms="" link=""/>
			<team fullname="Naval" phrase="Naval" searchterms="" link=""/>
			<team fullname="Olhanense" phrase="Olhanense" searchterms="" link=""/>
                        <team fullname="Pacos de Ferreira" phrase="Pacos de Ferreira" searchterms="" link=""/>
                        <team fullname="Portimonense" phrase="Portimonense" searchterms="" link=""/>
                        <team fullname="Porto" phrase="Porto" searchterms="" link=""/>
                        <team fullname="Rio Ave" phrase="Rio Ave" searchterms="" link=""/>
			<team fullname="Sporting Lisbon" phrase="Sporting Lisbon" searchterms="" link=""/>
			<team fullname="Uniao de Leiria" phrase="Uniao de Leiria" searchterms="" link=""/>
			<team fullname="Vitoria Guimaraes" phrase="Vitoria Guimaraes" searchterms="" link=""/>
                        <team fullname="Vitoria Setubal" phrase="Vitoria Setubal" searchterms="" link=""/>
		</competition>
		<competition name="Russian" phrase="Russian" sport="Football">			
                        <team fullname="CSKA Moscow" phrase="CSKA Moscow" searchterms="" link=""/>
                        <team fullname="Dinamo Moscow" phrase="Dinamo Moscow" searchterms="" link=""/>
                        <team fullname="Lokomotiv Moscow" phrase="Lokomotiv Moscow" searchterms="" link=""/>
                        <team fullname="Rubin Kazan" phrase="Rubin Kazan" searchterms="" link=""/>
                        <team fullname="Spartak Moscow" phrase="Spartak Moscow" searchterms="" link=""/>
                        <team fullname="Zenit St Petersburg" phrase="Zenit St Petersburg" searchterms="" link=""/>
		</competition>
		<competition name="Spanish" phrase="Spanish" sport="Football">
			<team fullname="Almeria" phrase="Almeria" searchterms="" link=""/>
                        <team fullname="Athletic Bilbao" phrase="Athletic Bilbao" searchterms="" link=""/>
			<team fullname="Atletico Madrid" phrase="Atletico Madrid" searchterms="" link=""/>
			<team fullname="Barcelona" phrase="Barcelona" searchterms="" link=""/>
			<team fullname="Deportivo La Coruna" phrase="Deportivo La Coruna" searchterms="" link=""/>
			<team fullname="Espanyol" phrase="Espanyol" searchterms="" link=""/>
			<team fullname="Getafe" phrase="Getafe" searchterms="" link=""/>
			<team fullname="Hercules" phrase="Hercules" searchterms="" link=""/>
                        <team fullname="Levante" phrase="Levante" searchterms="" link=""/>
                        <team fullname="Malaga" phrase="Malaga" searchterms="" link=""/>
			<team fullname="Mallorca" phrase="Mallorca" searchterms="" link=""/>
			<team fullname="Osasuna" phrase="Osasuna" searchterms="" link=""/>
			<team fullname="Racing Santander" phrase="Racing Santander" searchterms="" link=""/>
			<team fullname="Real Madrid" phrase="Real Madrid" searchterms="" link=""/>
			<team fullname="Real Sociedad" phrase="Real Sociedad" searchterms="" link=""/>
			<team fullname="Sevilla" phrase="Sevilla" searchterms="" link=""/>
			<team fullname="Sporting Gijon" phrase="Sporting Gijon" searchterms="" link=""/>
                        <team fullname="Valencia" phrase="Valencia" searchterms="" link=""/>
                        <team fullname="Villarreal" phrase="Villarreal" searchterms="" link=""/>
                        <team fullname="Real Zaragoza" phrase="Real Zaragoza" searchterms="" link=""/>
		</competition>
		<competition name="Swedish" phrase="Swedish" sport="Football">
			<team fullname="AIK" phrase="AIK" searchterms="" link=""/>
			<team fullname="Atvidaberg" phrase="Atvidaberg" searchterms="" link=""/>
                        <team fullname="Brommapojkarna" phrase="Brommapojkarna" searchterms="" link=""/>
                        <team fullname="Djurgarden" phrase="Djurgardens IF" searchterms="" link=""/>
			<team fullname="Elfsborg" phrase="Elfsborg" searchterms="" link=""/>
                        <team fullname="GAIS" phrase="GAIS" searchterms="" link=""/>
			<team fullname="Gefle" phrase="Gefle IF" searchterms="" link=""/>
			<team fullname="Hacken" phrase="Hacken" searchterms="" link=""/>
                        <team fullname="Halmstad" phrase="Halmstads BK" searchterms="" link=""/>
			<team fullname="Helsingborg" phrase="Helsingborg" searchterms="" link=""/>
			<team fullname="IFK Goteborg" phrase="IFK Goteborg" searchterms="" link=""/>
			<team fullname="Kalmar" phrase="Kalmar FF" searchterms="" link=""/>
			<team fullname="Malmo FF" phrase="Malmo FF" searchterms="" link=""/>
			<team fullname="Mjallby" phrase="Mjallby" searchterms="" link=""/>
                        <team fullname="Orebro" phrase="Orebro SK" searchterms="" link=""/>
			<team fullname="Trelleborgs FF" phrase="Trelleborgs FF" searchterms="" link=""/>
		</competition>
		<competition name="Swiss" phrase="Swiss" sport="Football">
			<team fullname="Basle" phrase="Basle" searchterms="" link=""/>
			<team fullname="Bellinzona" phrase="Bellinzona" searchterms="" link=""/>
                        <team fullname="Grasshoppers" phrase="Grasshoppers" searchterms="" link=""/>
                        <team fullname="Lucerne" phrase="Lucerne" searchterms="" link=""/>
                        <team fullname="Neuchatel Xamax" phrase="Neuchatel Xamax" searchterms="" link=""/>
                        <team fullname="Sion" phrase="FC Sion" searchterms="" link=""/>
			<team fullname="St Gallen" phrase="St Gallen" searchterms="" link=""/>
                        <team fullname="Thun" phrase="Thun" searchterms="" link=""/>
                        <team fullname="Young Boys" phrase="Young Boys" searchterms="" link=""/>
                        <team fullname="Zurich" phrase="FC Zurich" searchterms="" link=""/>
		</competition>
		<competition name="Turkish" phrase="Turkish" sport="Football">
			<team fullname="Ankaragucu" phrase="Ankaragucu" searchterms="" link=""/>
			<team fullname="Antalyaspor" phrase="Antalyaspor" searchterms="" link=""/>
			<team fullname="Besiktas" phrase="Besiktas" searchterms="" link=""/>
			<team fullname="Bucaspor" phrase="Young Boys" searchterms="" link=""/>
                        <team fullname="Bursaspor" phrase="Bursaspor" searchterms="" link=""/>
			<team fullname="Eskisehirspor" phrase="Eskisehirspor" searchterms="" link=""/>
			<team fullname="Fenerbahce" phrase="Fenerbahce" searchterms="" link=""/>
			<team fullname="Galatasaray" phrase="Galatasaray" searchterms="" link=""/>
			<team fullname="Gaziantepspor" phrase="Gaziantepspor" searchterms="" link=""/>
			<team fullname="Genclerbirligi" phrase="Genclerbirligi" searchterms="" link=""/>
			<team fullname="Istanbul Buyuksehir" phrase="Istanbul Buyuksehir" searchterms="" link=""/>
                        <team fullname="Karabukspor" phrase="Karabukspor" searchterms="" link=""/>
                        <team fullname="Kasimpasa" phrase="Kasimpasa" searchterms="" link=""/>
                        <team fullname="Kayserispor" phrase="Kayserispor" searchterms="" link=""/>
			<team fullname="Konyaspor" phrase="Konyaspor" searchterms="" link=""/>
			<team fullname="Manisaspor" phrase="Manisaspor" searchterms="" link=""/>
                        <team fullname="Sivasspor" phrase="Sivasspor" searchterms="" link=""/>
			<team fullname="Trabzonspor" phrase="Trabzonspor" searchterms="" link=""/>
		</competition>
		
		<!--INTERNATIONAL FOOTBALL -->
		<competition name="MAJOR COMPETITIONS" phrase="Major Competitions" sport="Football" hide="yes" hidefromteam="yes">
			<team fullname="World Cup" phrase="World Cup" searchterms="" link=""/>
			<team fullname="Olympics Football" phrase="Olympics Football" searchterms="" link=""/>
		</competition>
		<competition name="MAJOR COMPETITIONS 2" phrase="Major Competitions 2" sport="Football" hide="yes" hidefromteam="yes">
			<team fullname="Euro 2012" phrase="Euro 2012" searchterms="" link=""/>
                        <team fullname="Euro 2016" phrase="Euro 2016" searchterms="" link=""/>
                        <team fullname="Copa America" phrase="Copa America" searchterms="" link=""/>
		</competition>
		<competition name="MAJOR COMPETITIONS 3" phrase="Major Competitions 3" sport="Football" hide="yes" hidefromteam="yes">
			<team fullname="African" phrase="African" searchterms="" link=""/>
                        <team fullname="Africa Cup of Nations" phrase="Africa Cup of Nations" searchterms="" link=""/>
			<team fullname="Confederations Cup" phrase="Confederations Cup" searchterms="" link=""/>
		</competition>
		<competition name="MAJOR COMPETITIONS 4" phrase="Major Competitions 4" sport="Football" hide="yes" hidefromteam="yes">
			<team fullname="Women's World Cup" phrase="Womens World Cup" searchterms="" link=""/>
		</competition>
		<competition name="TEAMS" phrase="Teams" sport="Football" hide="yes">
			<team fullname="Afghanistan" phrase="Afghanistan" searchterms="" link=""/>
			<team fullname="Albania" phrase="Albania" searchterms="" link=""/>
			<team fullname="Algeria" phrase="Algeria" searchterms="" link=""/>
			<team fullname="American Samoa" phrase="American Samoa" searchterms="" link=""/>
			<team fullname="Andorra" phrase="Andorra" searchterms="" link=""/>
			<team fullname="Angola" phrase="Angola" searchterms="" link=""/>
			<team fullname="Anguilla" phrase="Anguilla" searchterms="" link=""/>
			<team fullname="Antigua and Barbuda" phrase="Antigua and Barbuda" searchterms="" link=""/>
			<team fullname="Argentina" phrase="Argentina" searchterms="" link=""/>
			<team fullname="Armenia" phrase="Armenia" searchterms="" link=""/>
			<team fullname="Aruba" phrase="Aruba" searchterms="" link=""/>
			<team fullname="Australia" phrase="Australia" searchterms="" link=""/>
			<team fullname="Austria" phrase="Austria" searchterms="" link=""/>
			<team fullname="Azerbaijan" phrase="Azerbaijan" searchterms="" link=""/>
			<team fullname="Bahamas" phrase="Bahamas" searchterms="" link=""/>
			<team fullname="Bahrain" phrase="Bahrain" searchterms="" link=""/>
			<team fullname="Bangladesh" phrase="Bangladesh" searchterms="" link=""/>
			<team fullname="Barbados" phrase="Barbados" searchterms="" link=""/>
			<team fullname="Belarus" phrase="Belarus" searchterms="" link=""/>
			<team fullname="Belgium" phrase="Belgium" searchterms="" link=""/>
			<team fullname="Belize" phrase="Belize" searchterms="" link=""/>
			<team fullname="Benin" phrase="Benin" searchterms="" link=""/>
			<team fullname="Bermuda" phrase="Bermuda" searchterms="" link=""/>
			<team fullname="Bhutan" phrase="Bhutan" searchterms="" link=""/>
			<team fullname="Bolivia" phrase="Bolivia" searchterms="" link=""/>
			<team fullname="Bosnia-Herzegovina" phrase="Bosnia-Herzegovina" searchterms="" link=""/>
			<team fullname="Botswana" phrase="Botswana" searchterms="" link=""/>
			<team fullname="Brazil" phrase="Brazil" searchterms="" link=""/>
			<team fullname="British Virgin Islands" phrase="British Virgin Islands" searchterms="" link=""/>
			<team fullname="Brunei Darussalam" phrase="Brunei Darussalam" searchterms="" link=""/>
			<team fullname="Bulgaria" phrase="Bulgaria" searchterms="" link=""/>
			<team fullname="Burkina Faso" phrase="Burkina Faso" searchterms="" link=""/>
			<team fullname="Burundi" phrase="Burundi" searchterms="" link=""/>
			<team fullname="Cambodia" phrase="Cambodia" searchterms="" link=""/>
			<team fullname="Cameroon" phrase="Cameroon" searchterms="" link=""/>
			<team fullname="Canada" phrase="Canada" searchterms="" link=""/>
			<team fullname="Cape Verde Islands" phrase="Cape Verde Islands" searchterms="" link=""/>
			<team fullname="Cayman Islands" phrase="Cayman Islands" searchterms="" link=""/>
			<team fullname="Central African Republic" phrase="Central African Republic" searchterms="" link=""/>
			<team fullname="Chad" phrase="Chad" searchterms="" link=""/>
			<team fullname="Chile" phrase="Chile" searchterms="" link=""/>
			<team fullname="China PR" phrase="China PR" searchterms="" link=""/>
			<team fullname="Chinese Taipei" phrase="Chinese Taipei" searchterms="" link=""/>
			<team fullname="Colombia" phrase="Colombia" searchterms="" link=""/>
			<team fullname="Comoros" phrase="Comoros" searchterms="" link=""/>
			<team fullname="Congo" phrase="Congo" searchterms="" link=""/>
			<team fullname="Congo DR" phrase="Congo DR" searchterms="" link=""/>
			<team fullname="Cook Islands" phrase="Cook Islands" searchterms="" link=""/>
			<team fullname="Costa Rica" phrase="Costa Rica" searchterms="" link=""/>
			<team fullname="Cote d'Ivoire" phrase="Cote dIvoire" searchterms="" link=""/>
			<team fullname="Croatia" phrase="Croatia" searchterms="" link=""/>
			<team fullname="Cuba" phrase="Cuba" searchterms="" link=""/>
		</competition>
		<competition name="TEAMS 2" phrase="Teams 2" sport="Football" hide="yes">
			<team fullname="Cyprus" phrase="Cyprus" searchterms="" link=""/>
			<team fullname="Czech Republic" phrase="Czech Republic" searchterms="" link=""/>
			<team fullname="Denmark" phrase="Denmark" searchterms="" link=""/>
			<team fullname="Djibouti" phrase="Djibouti" searchterms="" link=""/>
			<team fullname="Dominica" phrase="Dominica" searchterms="" link=""/>
			<team fullname="Dominican Republic" phrase="Dominican Republic" searchterms="" link=""/>
			<team fullname="Ecuador" phrase="Ecuador" searchterms="" link=""/>
			<team fullname="Egypt" phrase="Egypt" searchterms="" link=""/>
			<team fullname="El Salvador" phrase="El Salvador" searchterms="" link=""/>
			<team fullname="England" phrase="England" searchterms="" link=""/>
			<team fullname="Equatorial Guinea" phrase="Equatorial Guinea" searchterms="" link=""/>
			<team fullname="Eritrea" phrase="Eritrea" searchterms="" link=""/>
			<team fullname="Estonia" phrase="Estonia" searchterms="" link=""/>
			<team fullname="Ethiopia" phrase="Ethiopia" searchterms="" link=""/>
			<team fullname="Faroe Islands" phrase="Faroe Islands" searchterms="" link=""/>
			<team fullname="Fiji" phrase="Fiji" searchterms="" link=""/>
			<team fullname="Finland" phrase="Finland" searchterms="" link=""/>
			<team fullname="France" phrase="France" searchterms="" link=""/>
			<team fullname="FYR Macedonia" phrase="FYR Macedonia" searchterms="" link=""/>
			<team fullname="Gabon" phrase="Gabon" searchterms="" link=""/>
			<team fullname="Gambia" phrase="Gambia" searchterms="" link=""/>
			<team fullname="Georgia" phrase="Georgia" searchterms="" link=""/>
			<team fullname="Germany" phrase="Germany" searchterms="" link=""/>
			<team fullname="Ghana" phrase="Ghana" searchterms="" link=""/>
			<team fullname="Greece" phrase="Greece" searchterms="" link=""/>
			<team fullname="Grenada" phrase="Grenada" searchterms="" link=""/>
			<team fullname="Guam" phrase="Guam" searchterms="" link=""/>
			<team fullname="Guatemala" phrase="Guatemala" searchterms="" link=""/>
			<team fullname="Guinea" phrase="Guinea" searchterms="" link=""/>
			<team fullname="Guinea-Bissau" phrase="Guinea-Bissau" searchterms="" link=""/>
			<team fullname="Guyana" phrase="Guyana" searchterms="" link=""/>
			<team fullname="Haiti" phrase="Haiti" searchterms="" link=""/>
			<team fullname="Honduras" phrase="Honduras" searchterms="" link=""/>
			<team fullname="Hong Kong" phrase="Hong Kong" searchterms="" link=""/>
			<team fullname="Hungary" phrase="Hungary" searchterms="" link=""/>
			<team fullname="Iceland" phrase="Iceland" searchterms="" link=""/>
			<team fullname="India" phrase="India" searchterms="" link=""/>
			<team fullname="Indonesia" phrase="Indonesia" searchterms="" link=""/>
			<team fullname="Iran" phrase="Iran" searchterms="" link=""/>
			<team fullname="Iraq" phrase="Iraq" searchterms="" link=""/>
			<team fullname="Israel" phrase="Israel" searchterms="" link=""/>
			<team fullname="Italy" phrase="Italy" searchterms="" link=""/>
			<team fullname="Jamaica" phrase="Jamaica" searchterms="" link=""/>
			<team fullname="Japan" phrase="Japan" searchterms="" link=""/>
			<team fullname="Jordan" phrase="Jordan" searchterms="" link=""/>
			<team fullname="Kazakhstan" phrase="Kazakhstan" searchterms="" link=""/>
			<team fullname="Kenya" phrase="Kenya" searchterms="" link=""/>
			<team fullname="Korea DPR" phrase="Korea DPR" searchterms="" link=""/>
			<team fullname="Korea Republic" phrase="Korea Republic" searchterms="" link=""/>
			<team fullname="Kuwait" phrase="Kuwait" searchterms="" link=""/>
			<team fullname="Kyrgyzstan" phrase="Kyrgyzstan" searchterms="" link=""/>
			<team fullname="Laos" phrase="Laos" searchterms="" link=""/>
		</competition>
		<competition name="TEAMS 3" phrase="Teams 3" sport="Football" hide="yes">
			<team fullname="Latvia" phrase="Latvia" searchterms="" link=""/>
			<team fullname="Lebanon" phrase="Lebanon" searchterms="" link=""/>
			<team fullname="Lesotho" phrase="Lesotho" searchterms="" link=""/>
			<team fullname="Liberia" phrase="Liberia" searchterms="" link=""/>
			<team fullname="Libya" phrase="Libya" searchterms="" link=""/>
			<team fullname="Liechtenstein" phrase="Liechtenstein" searchterms="" link=""/>
			<team fullname="Lithuania" phrase="Lithuania" searchterms="" link=""/>
			<team fullname="Luxembourg" phrase="Luxembourg" searchterms="" link=""/>
			<team fullname="Macau" phrase="Macau" searchterms="" link=""/>
			<team fullname="Madagascar" phrase="Madagascar" searchterms="" link=""/>
			<team fullname="Malawi" phrase="Malawi" searchterms="" link=""/>
			<team fullname="Malaysia" phrase="Malaysia" searchterms="" link=""/>
			<team fullname="Maldives" phrase="Maldives" searchterms="" link=""/>
			<team fullname="Mali" phrase="Mali" searchterms="" link=""/>
			<team fullname="Malta" phrase="Malta" searchterms="" link=""/>
			<team fullname="Mauritania" phrase="Mauritania" searchterms="" link=""/>
			<team fullname="Mauritius" phrase="Mauritius" searchterms="" link=""/>
			<team fullname="Mexico" phrase="Mexico" searchterms="" link=""/>
			<team fullname="Moldova" phrase="Moldova" searchterms="" link=""/>
			<team fullname="Mongolia" phrase="Mongolia" searchterms="" link=""/>
			<team fullname="Montserrat" phrase="Montserrat" searchterms="" link=""/>
			<team fullname="Morocco" phrase="Morocco" searchterms="" link=""/>
			<team fullname="Mozambique" phrase="Mozambique" searchterms="" link=""/>
			<team fullname="Myanmar" phrase="Myanmar" searchterms="" link=""/>
			<team fullname="Namibia" phrase="Namibia" searchterms="" link=""/>
			<team fullname="Nepal" phrase="Nepal" searchterms="" link=""/>
			<team fullname="Netherlands" phrase="Netherlands" searchterms="" link=""/>
			<team fullname="Netherlands Antilles" phrase="Netherlands Antilles" searchterms="" link=""/>
			<team fullname="New Caledonia" phrase="New Caledonia" searchterms="" link=""/>
			<team fullname="New Zealand" phrase="New Zealand" searchterms="" link=""/>
			<team fullname="Nicaragua" phrase="Nicaragua" searchterms="" link=""/>
			<team fullname="Niger" phrase="Niger" searchterms="" link=""/>
			<team fullname="Nigeria" phrase="Nigeria" searchterms="" link=""/>
			<team fullname="Northern Ireland" phrase="Northern Ireland" searchterms="" link=""/>
			<team fullname="Norway" phrase="Norway" searchterms="" link=""/>
			<team fullname="Oman" phrase="Oman" searchterms="" link=""/>
			<team fullname="Pakistan" phrase="Pakistan" searchterms="" link=""/>
			<team fullname="Palestine" phrase="Palestine" searchterms="" link=""/>
			<team fullname="Panama" phrase="Panama" searchterms="" link=""/>
			<team fullname="Papua New Guinea" phrase="Papua New Guinea" searchterms="" link=""/>
			<team fullname="Paraguay" phrase="Paraguay" searchterms="" link=""/>
			<team fullname="Peru" phrase="Peru" searchterms="" link=""/>
			<team fullname="Philippines" phrase="Philippines" searchterms="" link=""/>
			<team fullname="Poland" phrase="Poland" searchterms="" link=""/>
			<team fullname="Portugal" phrase="Portugal" searchterms="" link=""/>
			<team fullname="Puerto Rico" phrase="Puerto Rico" searchterms="" link=""/>
			<team fullname="Qatar" phrase="Qatar" searchterms="" link=""/>
			<team fullname="Republic of Ireland" phrase="Republic of Ireland" searchterms="" link=""/>
			<team fullname="Romania" phrase="Romania" searchterms="" link=""/>
			<team fullname="Russia" phrase="Russia" searchterms="" link=""/>
			<team fullname="Rwanda" phrase="Rwanda" searchterms="" link=""/>
			<team fullname="Samoa" phrase="Samoa" searchterms="" link=""/>
		</competition>
		<competition name="TEAMS 4" phrase="Teams 4" sport="Football" hide="yes">
			<team fullname="San Marino" phrase="San Marino" searchterms="" link=""/>
			<team fullname="Sao Tome and Principe" phrase="Sao Tome and Principe" searchterms="" link=""/>
			<team fullname="Saudi Arabia" phrase="Saudi Arabia" searchterms="" link=""/>
			<team fullname="Scotland" phrase="Scotland" searchterms="" link=""/>
			<team fullname="Senegal" phrase="Senegal" searchterms="" link=""/>
			<team fullname="Serbia" phrase="Serbia" searchterms="" link=""/>
			<team fullname="Seychelles" phrase="Seychelles" searchterms="" link=""/>
			<team fullname="Sierra Leone" phrase="Sierra Leone" searchterms="" link=""/>
			<team fullname="Singapore" phrase="Singapore" searchterms="" link=""/>
			<team fullname="Slovakia" phrase="Slovakia" searchterms="" link=""/>
			<team fullname="Slovenia" phrase="Slovenia" searchterms="" link=""/>
			<team fullname="Solomon Islands" phrase="Solomon Islands" searchterms="" link=""/>
			<team fullname="Somalia" phrase="Somalia" searchterms="" link=""/>
			<team fullname="South Africa" phrase="South Africa" searchterms="" link=""/>
			<team fullname="Spain" phrase="Spain" searchterms="" link=""/>
			<team fullname="Sri Lanka" phrase="Sri Lanka" searchterms="" link=""/>
			<team fullname="St. Kitts and Nevis" phrase="St. Kitts and Nevis" searchterms="" link=""/>
			<team fullname="St. Lucia" phrase="St. Lucia" searchterms="" link=""/>
			<team fullname="St. Vincent and the Grenadines" phrase="St. Vincent and the Grenadines" searchterms="" link=""/>
			<team fullname="Sudan" phrase="Sudan" searchterms="" link=""/>
			<team fullname="Surinam" phrase="Surinam" searchterms="" link=""/>
			<team fullname="Swaziland" phrase="Swaziland" searchterms="" link=""/>
			<team fullname="Sweden" phrase="Sweden" searchterms="" link=""/>
			<team fullname="Switzerland" phrase="Switzerland" searchterms="" link=""/>
			<team fullname="Syria" phrase="Syria" searchterms="" link=""/>
			<team fullname="Tahiti" phrase="Tahiti" searchterms="" link=""/>
			<team fullname="Tajikistan" phrase="Tajikistan" searchterms="" link=""/>
			<team fullname="Tanzania" phrase="Tanzania" searchterms="" link=""/>
			<team fullname="Thailand" phrase="Thailand" searchterms="" link=""/>
			<team fullname="Timor-Leste" phrase="Timor-Leste" searchterms="" link=""/>
			<team fullname="Togo" phrase="Togo" searchterms="" link=""/>
			<team fullname="Tonga" phrase="Tonga" searchterms="" link=""/>
			<team fullname="Trinidad and Tobago" phrase="Trinidad and Tobago" searchterms="" link=""/>
			<team fullname="Tunisia" phrase="Tunisia" searchterms="" link=""/>
			<team fullname="Turkey" phrase="Turkey" searchterms="" link=""/>
			<team fullname="Turkmenistan" phrase="Turkmenistan" searchterms="" link=""/>
			<team fullname="Turks and Caicos Islands" phrase="Turks and Caicos Islands" searchterms="" link=""/>
			<team fullname="Uganda" phrase="Uganda" searchterms="" link=""/>
			<team fullname="Ukraine" phrase="Ukraine" searchterms="" link=""/>
			<team fullname="United Arab Emirates" phrase="United Arab Emirates" searchterms="" link=""/>
			<team fullname="Uruguay" phrase="Uruguay" searchterms="" link=""/>
			<team fullname="US Virgin Islands" phrase="US Virgin Islands" searchterms="" link=""/>
			<team fullname="USA" phrase="USA" searchterms="" link=""/>
			<team fullname="Uzbekistan" phrase="Uzbekistan" searchterms="" link=""/>
			<team fullname="Vanuatu" phrase="Vanuatu" searchterms="" link=""/>
			<team fullname="Venezuela" phrase="Venezuela" searchterms="" link=""/>
			<team fullname="Vietnam" phrase="Vietnam" searchterms="" link=""/>
			<team fullname="Wales" phrase="Wales" searchterms="" link=""/>
			<team fullname="Yemen" phrase="Yemen" searchterms="" link=""/>
			<team fullname="Zambia" phrase="Zambia" searchterms="" link=""/>
			<team fullname="Zimbabwe" phrase="Zimbabwe" searchterms="" link=""/>
		</competition>

		<!-- CRICKET -->
		<competition sport="Cricket" converted="cricket" name="International" phrase="International" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/default.stm" hide="yes">
				<team fullname="Australia" phrase="Australia" searchterms="" link=""/>
				<team fullname="Bangladesh" phrase="Bangladesh" searchterms="" link=""/>
				<team fullname="Bermuda" phrase="Bermuda" searchterms="" link=""/>
				<team fullname="Canada" phrase="Canada" searchterms="" link=""/>
				<team fullname="England" phrase="England" searchterms="" link=""/>
				<team fullname="Holland" phrase="Holland" searchterms="" link=""/>
				<team fullname="India" phrase="India" searchterms="" link=""/>
				<team fullname="Ireland" phrase="Ireland" searchterms="" link=""/>
				<team fullname="Kenya" phrase="Kenya" searchterms="" link=""/>
				<team fullname="New Zealand" phrase="New Zealand" searchterms="" link=""/>
				<team fullname="Pakistan" phrase="Pakistan" searchterms="" link=""/>
				<team fullname="Scotland" phrase="Scotland" searchterms="" link=""/>
				<team fullname="South Africa" phrase="South Africa" searchterms="" link=""/>
				<team fullname="Sri Lanka" phrase="Sri Lanka" searchterms="" link=""/>
				<team fullname="West Indies" phrase="West Indies" searchterms="" link=""/>
				<team fullname="Zimbabwe" phrase="Zimbabwe" searchterms="" link=""/>
		</competition>
		<competition sport="Cricket" converted="cricket" name="Tests" phrase="International Tests" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="One-day internationals" phrase="One-day internationals" searchterms="" link="" hidefromteam="yes">
			<team fullname="Australia" phrase="Australia" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/australia/default.stm"/>
			<team fullname="Bangladesh" phrase="Bangladesh" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/bangladesh/default.stm"/>
			<team fullname="England" phrase="England" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/england/default.stm"/>
			<team fullname="India" phrase="India" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/india/default.stm"/>
			<team fullname="New Zealand" phrase="New Zealand" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/new_zealand/default.stm"/>
			<team fullname="Pakistan" phrase="Pakistan" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/pakistan/default.stm"/>
			<team fullname="South Africa" phrase="South Africa" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/south_africa/default.stm"/>
			<team fullname="Sri Lanka" phrase="Sri Lanka" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/sri_lanka/default.stm"/>
			<team fullname="West Indies" phrase="West Indies" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/west_indies/default.stm"/>
			<team fullname="Zimbabwe" phrase="Zimbabwe" searchterms="" link="http://news.bbc.co.uk/sport1/hi/cricket/other_international/zimbabwe/default.stm"/>
		</competition>
		<competition sport="Cricket" converted="cricket" name="World Cup" phrase="World Cup" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="The Ashes" phrase="The Ashes" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="County cricket" phrase="County cricket" searchterms="" link="">
				<team fullname="Derbyshire" phrase="Derbyshire" searchterms="" link=""/>
				<team fullname="Durham" phrase="Durham" searchterms="" link=""/>
				<team fullname="Essex" phrase="Essex" searchterms="" link=""/>
				<team fullname="Glamorgan" phrase="Glamorgan" searchterms="" link=""/>
				<team fullname="Gloucestershire" phrase="Gloucestershire" searchterms="" link=""/>
				<team fullname="Hampshire" phrase="Hampshire" searchterms="" link=""/>
				<team fullname="Kent" phrase="Kent" searchterms="" link=""/>
				<team fullname="Lancashire" phrase="Lancashire" searchterms="" link=""/>
				<team fullname="Leicestershire" phrase="Leicestershire" searchterms="" link=""/>
				<team fullname="Middlesex" phrase="Middlesex" searchterms="" link=""/>
				<team fullname="Northants" phrase="Northants" searchterms="" link=""/>
				<team fullname="Nottinghamshire" phrase="Nottinghamshire" searchterms="" link=""/>
				<team fullname="Somerset" phrase="Somerset" searchterms="" link=""/>
				<team fullname="Surrey" phrase="Surrey" searchterms="" link=""/>
				<team fullname="Sussex" phrase="Sussex" searchterms="" link=""/>
				<team fullname="Warwickshire" phrase="Warwickshire" searchterms="" link=""/>
				<team fullname="Worcestershire" phrase="Worcestershire" searchterms="" link=""/>
				<team fullname="Yorkshire" phrase="Yorkshire" searchterms="" link=""/>
		</competition>
		<competition sport="Cricket" converted="cricket" name="County championship" phrase="County championship" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="Twenty20" phrase="Twenty20" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="Pro40" phrase="Pro40" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="Friends Provident Trophy" phrase="Friends Provident Trophy" searchterms="" link=""/>
		<competition sport="Cricket" converted="cricket" name="Minor Counties" phrase="Minor Counties" searchterms="" link="">
			<team fullname="Bedfordshire" phrase="Bedfordshire" searchterms="" link=""/>
			<team fullname="Berkshire" phrase="Berkshire" searchterms="" link=""/>
			<team fullname="Buckinghamshire" phrase="Buckinghamshire" searchterms="" link=""/>
			<team fullname="Cambridgeshire" phrase="Cambridgeshire" searchterms="" link=""/>
			<team fullname="Cheshire" phrase="Cheshire" searchterms="" link=""/>
			<team fullname="Cornwall" phrase="Cornwall" searchterms="" link=""/>
			<team fullname="Cumberland" phrase="Cumberland" searchterms="" link=""/>
			<team fullname="Devon" phrase="Devon" searchterms="" link=""/>
			<team fullname="Dorset" phrase="Dorset" searchterms="" link=""/>
			<team fullname="Herefordshire" phrase="Herefordshire" searchterms="" link=""/>
			<team fullname="Hertfordshire" phrase="Hertfordshire" searchterms="" link=""/>
			<team fullname="Lincolnshire" phrase="Lincolnshire" searchterms="" link=""/>
			<team fullname="Norfolk" phrase="Norfolk" searchterms="" link=""/>
			<team fullname="Northumberland" phrase="Northumberland" searchterms="" link=""/>
			<team fullname="Oxfordshire" phrase="Oxfordshire" searchterms="" link=""/>
			<team fullname="Shropshire" phrase="Shropshire" searchterms="" link=""/>
			<team fullname="Staffordshire" phrase="Staffordshire" searchterms="" link=""/>
			<team fullname="Suffolk" phrase="Suffolk" searchterms="" link=""/>
			<team fullname="Wales MC" phrase="Wales MC" searchterms="" link=""/>
			<team fullname="Wiltshire" phrase="Wiltshire" searchterms="" link=""/>
		</competition>
		<competition sport="Cricket" converted="cricket" name="Competitions" phrase="Competitions" searchterms="" link="" hide="yes" hidefromteam="yes">
			<team fullname="Tests" phrase="Tests" searchterms="" link=""/>
			<team fullname="One-day internationals" phrase="One-day internationals" searchterms="" link=""/>
			<team fullname="World Cup" phrase="World Cup" searchterms="" link=""/>
			<team fullname="World Twenty20" phrase="World Twenty20" searchterms="" link=""/>
                        <team fullname="The Ashes" phrase="The Ashes" searchterms="" link=""/>
			<team fullname="County championship" phrase="County championship" searchterms="" link=""/>
			<team fullname="Twenty20" phrase="Twenty20" searchterms="" link=""/>
			<team fullname="Pro40" phrase="Pro40" searchterms="" link=""/>
			<team fullname="Friends Provident Trophy" phrase="Friends Provident Trophy" searchterms="" link=""/>
		</competition>
		
		<!-- RUGBY UNION -->
		<competition sport="Rugby union" converted="rugbyunion" name="Six Nations" phrase="Six Nations" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/default.stm" hidefromteam="yes">
			<team fullname="England" phrase="England" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/english/default.stm"/>
			<team fullname="France" phrase="France" searchterms="" link=""/>
			<team fullname="Ireland" phrase="Ireland" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/irish/default.stm"/>
			<team fullname="Italy" phrase="Italy" searchterms="" link=""/>
			<team fullname="Scotland" phrase="Scotland" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/scottish/default.stm"/>
			<team fullname="Wales" phrase="Wales" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/welsh/default.stm"/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="International" phrase="International" searchterms="" link="">
			<team fullname="Lions" phrase="Lions" searchterms="" link=""/>
 			<team fullname="Barbarians" phrase="Barbarians" searchterms="" link=""/>
                        <team fullname="England" phrase="England" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/english/default.stm"/>
			<team fullname="France" phrase="France" searchterms="" link=""/>
			<team fullname="Ireland" phrase="Ireland" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/irish/default.stm"/>
			<team fullname="Italy" phrase="Italy" searchterms="" link=""/>
			<team fullname="Scotland" phrase="Scotland" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/scottish/default.stm"/>
			<team fullname="Wales" phrase="Wales" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/welsh/default.stm"/>
			<team fullname="Australia" phrase="Australia" searchterms="" link=""/>
			<team fullname="New Zealand" phrase="New Zealand" searchterms="" link=""/>
			<team fullname="South Africa" phrase="South Africa" searchterms="" link=""/>
			<team fullname="Argentina" phrase="Argentina" searchterms="" link=""/>
			<team fullname="Canada" phrase="Canada" searchterms="" link=""/>
			<team fullname="Fiji" phrase="Fiji" searchterms="" link=""/>
			<team fullname="Georgia" phrase="Georgia" searchterms="" link=""/>
			<team fullname="Japan" phrase="Japan" searchterms="" link=""/>
			<team fullname="Namibia " phrase="Namibia " searchterms="" link=""/>
			<team fullname="Portugal " phrase="Portugal " searchterms="" link=""/>
			<team fullname="Romania" phrase="Romania" searchterms="" link=""/>
			<team fullname="Samoa" phrase="Samoa" searchterms="" link=""/>
			<team fullname="Tonga" phrase="Tonga" searchterms="" link=""/>
			<team fullname="USA " phrase="USA " searchterms="" link=""/>
		</competition>
		
		<competition sport="Rugby union" converted="rugbyunion" name="European" phrase="European" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="English" phrase="English" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="Irish" phrase="Irish" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="Scottish" phrase="Scottish" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="Welsh" phrase="Welsh" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="French" phrase="French" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="Italian" phrase="Italian" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="European" phrase="European" searchterms="" link=""/>
		
		<competition sport="Rugby union" converted="rugbyunion" name="Premiership" phrase="Premiership" searchterms="" link="">
			<team fullname="Bath" phrase="Bath" searchterms="" link=""/>
			<team fullname="Exeter" phrase="Exeter" searchterms="" link=""/>
                        <team fullname="Gloucester" phrase="Gloucester" searchterms="" link=""/>
			<team fullname="Harlequins" phrase="Harlequins" searchterms="" link=""/>
			<team fullname="Leeds Carnegie" phrase="Leeds Carnegie" searchterms="" link=""/>
                        <team fullname="Leicester" phrase="Leicester" searchterms="" link=""/>
			<team fullname="London Irish" phrase="London Irish" searchterms="" link=""/>
			<team fullname="Newcastle" phrase="Newcastle" searchterms="" link=""/>
			<team fullname="Northampton" phrase="Northampton" searchterms="" link=""/>
                        <team fullname="Sale" phrase="Sale" searchterms="" link=""/>
			<team fullname="Saracens" phrase="Saracens" searchterms="" link=""/>
			<team fullname="Wasps" phrase="Wasps" searchterms="" link=""/>
                </competition>
		<competition sport="Rugby union" converted="rugbyunion" name="Magners League" phrase="MagnersLeague" searchterms="" link="">
			<team fullname="Aironi" phrase="Aironi" searchterms="" link=""/>
                        <team fullname="Cardiff Blues" phrase="Cardiff Blues" searchterms="" link=""/>
			<team fullname="Connacht" phrase="Connacht" searchterms="" link=""/>
			<team fullname="Edinburgh" phrase="Edinburgh" searchterms="" link=""/>
			<team fullname="Glasgow" phrase="Glasgow" searchterms="" link=""/>
			<team fullname="Leinster" phrase="Leinster" searchterms="" link=""/>
			<team fullname="Munster" phrase="Munster" searchterms="" link=""/>
			<team fullname="N-G Dragons" phrase="N-G Dragons" searchterms="" link=""/>
			<team fullname="Ospreys" phrase="Ospreys" searchterms="" link=""/>
			<team fullname="Scarlets" phrase="Scarlets" searchterms="" link=""/>
                        <team fullname="Treviso" phrase="Treviso" searchterms="" link=""/>
                        <team fullname="Ulster" phrase="Ulster" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="Super 15" phrase="Super 15" searchterms="" link="">
			<team fullname="Blues" phrase="Blues" searchterms="" link=""/>
			<team fullname="Brumbies" phrase="Brumbies" searchterms="" link=""/>
                        <team fullname="Bulls" phrase="Bulls" searchterms="" link=""/>
			<team fullname="Cheetahs" phrase="Cheetahs" searchterms="" link=""/>
                        <team fullname="Chiefs" phrase="Chiefs" searchterms="" link=""/>
                        <team fullname="Crusaders" phrase="Crusaders" searchterms="" link=""/>
                        <team fullname="Highlanders" phrase="Highlanders" searchterms="" link=""/>
			<team fullname="Hurricanes" phrase="Hurricanes" searchterms="" link=""/>
			<team fullname="Lions" phrase="Lions" searchterms="" link=""/>
			<team fullname="Rebels" phrase="Rebels" searchterms="" link=""/>
                        <team fullname="Reds" phrase="Reds" searchterms="" link=""/>
			<team fullname="Sharks" phrase="Sharks" searchterms="" link=""/>
                        <team fullname="Stormers" phrase="Stormers" searchterms="" link=""/>
			<team fullname="Waratahs" phrase="Waratahs" searchterms="" link=""/>
			<team fullname="Western Force" phrase="Western Force" searchterms="" link=""/>
			
		</competition>
		
		<competition sport="Rugby union" converted="rugbyunion" name="Rugby world cup" phrase="Rugby world cup" searchterms="" link=""/>
		<competition sport="Rugby union" converted="rugbyunion" name="Sevens" phrase="Sevens" searchterms="" link=""/>
		
		<competition name="COMPETITIONS" sport="Rugby union" converted="rugbyunion" phrase="Competitions" hide="yes" hidefromteam="yes">
			<team fullname="Six Nations" phrase="Six Nations" searchterms="" link=""/>
			<team fullname="Tri Nations" phrase="Tri Nations" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="COMPETITIONS 2" phrase="Competitions 2" hide="yes" hidefromteam="yes">
			<team fullname="Rugby World Cup" phrase="Rugby World Cup" searchterms="" link=""/>
			<team fullname="Sevens" phrase="Sevens" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="COMPETITIONS 3" phrase="Competitions 3" hide="yes" hidefromteam="yes">
			<team fullname="European club rugby" phrase="European club rugby" searchterms="" link=""/>
			<team fullname="Heineken Cup" phrase="Heineken Cup" searchterms="" link=""/>
                        <team fullname="European Challenge Cup" phrase="European Challenge Cup" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="COMPETITIONS 4" phrase="Competitions 4" hide="yes" hidefromteam="yes">
			<team fullname="French rugby" phrase="French rugby" searchterms="" link=""/>
			<team fullname="Italian rugby" phrase="Italian rugby" searchterms="" link=""/>
		</competition>
		
		<competition sport="Rugby union" converted="rugbyunion" name="MORE ENGLISH" phrase="MORE ENGLISH" hide="yes">
			<team fullname="Bedford" phrase="Bedford" searchterms="" link=""/>
			<team fullname="Birmingham-Solihull" phrase="Birmingham Solihull" searchterms="" link=""/>
                        <team fullname="Bristol" phrase="Bristol" searchterms="" link=""/>
                        <team fullname="Cornish Pirates" phrase="Cornish Pirates" searchterms="" link=""/>
			<team fullname="Doncaster" phrase="Doncaster" searchterms="" link=""/>
			<team fullname="Esher" phrase="Esher" searchterms="" link=""/>
			<team fullname="London Welsh" phrase="London Welsh" searchterms="" link=""/>
			<team fullname="Moseley" phrase="Moseley" searchterms="" link=""/>
                        <team fullname="Nottingham" phrase="Nottingham" searchterms="" link=""/>
			<team fullname="Plymouth Albion" phrase="Plymouth Albion" searchterms="" link=""/>
			<team fullname="Rotherham Titans" phrase="Rotherham Titans" searchterms="" link=""/>
                        <team fullname="Worcester" phrase="Worcester" searchterms="" link=""/>
                </competition>
		
		<competition sport="Rugby union" converted="rugbyunion" name="MORE IRISH" phrase="MORE IRISH" hide="yes">
			<team fullname="Ballymena " phrase="Ballymena " searchterms="" link=""/>
			<team fullname="Belfast Harlequins " phrase="Belfast Harlequins " searchterms="" link=""/>
			<team fullname="Blackrock College " phrase="Blackrock College " searchterms="" link=""/>
			<team fullname="Buccaneers " phrase="Buccaneers " searchterms="" link=""/>
			<team fullname="Clontarf " phrase="Clontarf " searchterms="" link=""/>
			<team fullname="Cork Constitution " phrase="Cork Constitution " searchterms="" link=""/>
			<team fullname="Dolphin " phrase="Dolphin " searchterms="" link=""/>
			<team fullname="Dungannon " phrase="Dungannon " searchterms="" link=""/>
			<team fullname="Galwegians " phrase="Galwegians " searchterms="" link=""/>
			<team fullname="Garryowen " phrase="Garryowen " searchterms="" link=""/>
			<team fullname="Lansdowne " phrase="Lansdowne " searchterms="" link=""/>
			<team fullname="Shannon " phrase="Shannon " searchterms="" link=""/>
			<team fullname="St Mary's College " phrase="St Marys College " searchterms="" link=""/>
			<team fullname="Terenure College " phrase="Terenure College " searchterms="" link=""/>
			<team fullname="UCD " phrase="UCD " searchterms="" link=""/>
			<team fullname="UL Bohemians " phrase="UL Bohemians " searchterms="" link=""/>
		</competition>
		
		<competition sport="Rugby union" converted="rugbyunion" name="MORE SCOTTISH" phrase="MORE SCOTTISH" hide="yes">
			<team fullname="Ayr " phrase="Ayr " searchterms="" link=""/>
			<team fullname="Boroughmuir " phrase="Boroughmuir " searchterms="" link=""/>
			<team fullname="Currie " phrase="Currie " searchterms="" link=""/>
			<team fullname="Dundee HSFP " phrase="Dundee HSFP " searchterms="" link=""/>
			<team fullname="Edinburgh Acads " phrase="Edinburgh Acads " searchterms="" link=""/>
			<team fullname="Glasgow Hawks " phrase="Glasgow Hawks " searchterms="" link=""/>
			<team fullname="Heriots Rugby Club " phrase="Heriots Rugby Club " searchterms="" link=""/>
			<team fullname="Melrose " phrase="Melrose " searchterms="" link=""/>
			<team fullname="Selkirk " phrase="Selkirk " searchterms="" link=""/>
			<team fullname="Stewart's Melville FP " phrase="Stewarts Melville FP " searchterms="" link=""/>
			<team fullname="Watsonians " phrase="Watsonians " searchterms="" link=""/>
			<team fullname="West of Scotland " phrase="West of Scotland " searchterms="" link=""/>
		</competition>
		
		<competition sport="Rugby union" converted="rugbyunion" name="MORE WELSH" phrase="MORE WELSH" hide="yes">
			<team fullname="Aberavon " phrase="Aberavon " searchterms="" link=""/>
			<team fullname="Bedwas " phrase="Bedwas " searchterms="" link=""/>
			<team fullname="Cardiff " phrase="Cardiff " searchterms="" link=""/>
                        <team fullname="Carmarthen Quins " phrase="Carmarthen Quins " searchterms="" link=""/>
			<team fullname="Cross Keys " phrase="Cross Keys " searchterms="" link=""/>
			<team fullname="Ebbw Vale " phrase="Ebbw Vale " searchterms="" link=""/>
			<team fullname="Glamorgan Wanderers " phrase="Glamorgan Wanderers " searchterms="" link=""/>
			<team fullname="Llandovery " phrase="Llandovery " searchterms="" link=""/>
			<team fullname="Llanelli " phrase="Llanelli " searchterms="" link=""/>
			<team fullname="Neath " phrase="Neath " searchterms="" link=""/>
			<team fullname="Newport " phrase="Newport " searchterms="" link=""/>
			<team fullname="Pontypool " phrase="Pontypool " searchterms="" link=""/>
			<team fullname="Pontypridd " phrase="Pontypridd " searchterms="" link=""/>
			<team fullname="Swansea " phrase="Swansea " searchterms="" link=""/>
		</competition>
		
		<!--
		<competition sport="Rugby union" converted="rugbyunion" name="European club rugby" phrase="European club rugby" searchterms="" link="" hidefromteam="yes" hide="yes">
			<team fullname="Bath" phrase="Bath" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/bath/default.stm"/>
			<team fullname="Cardiff Blues" phrase="Cardiff Blues" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/cardiff_blues/default.stm"/>
			<team fullname="Connacht" phrase="Connacht" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/connacht/default.stm"/>
			<team fullname="Edinburgh" phrase="Edinburgh" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/edinburgh/default.stm"/>
			<team fullname="Glasgow" phrase="Glasgow" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/glasgow/default.stm"/>
			<team fullname="Gloucester" phrase="Gloucester" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/gloucester/default.stm"/>
			<team fullname="Harlequins" phrase="Harlequins" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/harlequins/default.stm"/>
			<team fullname="Leeds Carnegie" phrase="Leeds Carnegie" searchterms="" link=""/>
                        <team fullname="Leicester" phrase="Leicester" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/leicester/default.stm"/>
			<team fullname="Leinster" phrase="Leinster" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/leinster/default.stm"/>
			<team fullname="Llanelli Scarlets" phrase="Llanelli Scarlets" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/llanelli_scarlets/default.stm"/>
			<team fullname="London Irish" phrase="London Irish" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/london_irish/default.stm"/>
			<team fullname="Munster" phrase="Munster" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/munster/default.stm"/>
			<team fullname="Newcastle" phrase="Newcastle" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/newcastle/default.stm"/>
			<team fullname="Newport-Gwent Dragons" phrase="Newport-Gwent Dragons" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/ng_dragons/default.stm"/>
			<team fullname="Northampton" phrase="Northampton" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/northampton/default.stm"/>
			<team fullname="Ospreys" phrase="Ospreys" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/ospreys/default.stm"/>
			<team fullname="Sale" phrase="Sale" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/sale/default.stm"/>
			<team fullname="Saracens" phrase="Saracens" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/saracens/default.stm"/>
			<team fullname="Ulster" phrase="Ulster" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/ulster/default.stm"/>
			<team fullname="Wasps" phrase="Wasps" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/london_wasps/default.stm"/>
			<team fullname="Worcester" phrase="Worcester" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/worcester/default.stm"/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="English club rugby" phrase="English club rugby" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/english/default.stm">
			<team fullname="Bath" phrase="Bath" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/bath/default.stm"/>
			<team fullname="Gloucester" phrase="Gloucester" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/gloucester/default.stm"/>
			<team fullname="Harlequins" phrase="Harlequins" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/harlequins/default.stm"/>
			<team fullname="Leeds Carnegie" phrase="Leeds Carnegie" searchterms="" link=""/>
                        <team fullname="Leicester" phrase="Leicester" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/leicester/default.stm"/>
			<team fullname="London Irish" phrase="London Irish" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/london_irish/default.stm"/>
			<team fullname="Newcastle" phrase="Newcastle" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/newcastle/default.stm"/>
			<team fullname="Northampton" phrase="Northampton" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/northampton/default.stm"/>
			<team fullname="Sale" phrase="Sale" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/sale/default.stm"/>
			<team fullname="Saracens" phrase="Saracens" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/saracens/default.stm"/>
			<team fullname="Wasps" phrase="Wasps" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/london_wasps/default.stm"/>
			<team fullname="Worcester" phrase="Worcester" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/worcester/default.stm"/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="Irish club rugby" phrase="Irish club rugby" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/irish/default.stm">
			<team fullname="Connacht" phrase="Connacht" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/connacht/default.stm"/>
			<team fullname="Leinster" phrase="Leinster" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/leinster/default.stm"/>
			<team fullname="Munster" phrase="Munster" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/munster/default.stm"/>
			<team fullname="Ulster" phrase="Ulster" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/ulster/default.stm"/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="Scottish club rugby" phrase="Scottish club rugby" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/scottish/default.stm">
			<team fullname="Edinburgh" phrase="Edinburgh" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/edinburgh/default.stm"/>
			<team fullname="Glasgow" phrase="Glasgow" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/glasgow/default.stm"/>
		</competition>
		<competition sport="Rugby union" converted="rugbyunion" name="Welsh club rugby" phrase="Welsh club rugby" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/welsh/default.stm">
			<team fullname="Cardiff Blues" phrase="Cardiff Blues" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/cardiff_blues/default.stm"/>
			<team fullname="Llanelli Scarlets" phrase="Llanelli Scarlets" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/llanelli_scarlets/default.stm"/>
			<team fullname="Newport-Gwent Dragons" phrase="Newport-Gwent Dragons" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/ng_dragons/default.stm"/>
			<team fullname="Ospreys" phrase="Ospreys" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_union/my_club/ospreys/default.stm"/>
		</competition>
		-->
		
		<!--RUGBY LEAGUE-->
		<competition sport="Rugby league" converted="rugbyleague" name="Super League" phrase="Super League" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_league/super_league/default.stm">
			<team fullname="Bradford" phrase="Bradford" searchterms="" link=""/>
			<team fullname="Castleford" phrase="Castleford" searchterms="" link=""/>
			<team fullname="Catalans" phrase="Catalans" searchterms="" link=""/>
			<team fullname="Crusaders" phrase="Crusaders" searchterms="" link=""/>
                        <team fullname="Harlequins" phrase="Harlequins" searchterms="" link=""/>
			<team fullname="Huddersfield" phrase="Huddersfield" searchterms="" link=""/>
			<team fullname="Hull" phrase="Hull" searchterms="" link=""/>
			<team fullname="Hull KR" phrase="Hull KR" searchterms="" link=""/>
			<team fullname="Leeds" phrase="Leeds" searchterms="" link=""/>
                        <team fullname="Salford" phrase="Salford" searchterms="" link=""/>
                        <team fullname="St Helens" phrase="St Helens" searchterms="" link=""/>
			<team fullname="Wakefield" phrase="Wakefield" searchterms="" link=""/>
			<team fullname="Warrington" phrase="Warrington" searchterms="" link=""/>
			<team fullname="Wigan" phrase="Wigan" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby league" converted="rugbyleague" name="International" phrase="International" searchterms="" link="http://news.bbc.co.uk/sport1/hi/rugby_league/international_and_australian/default.stm">
			<team fullname="Australia" phrase="Australia" searchterms="" link=""/>
			<team fullname="Great Britain" phrase="Great Britain" searchterms="" link=""/>
			<team fullname="New Zealand" phrase="New Zealand" searchterms="" link=""/>
			<team fullname="England" phrase="England" searchterms="" link=""/>
			<team fullname="Wales" phrase="Wales" searchterms="" link=""/>
			<team fullname="Ireland" phrase="Ireland" searchterms="" link=""/>
			<team fullname="Scotland" phrase="Scotland" searchterms="" link=""/>
			<team fullname="France" phrase="France" searchterms="" link=""/>
			<team fullname="Papua New Guinea" phrase="Papua New Guinea" searchterms="" link=""/>
                        <team fullname="Russia" phrase="Russia" searchterms="" link=""/>
			<team fullname="Tonga " phrase="Tonga " searchterms="" link=""/>
			<team fullname="Cook Islands" phrase="Cook Islands" searchterms="" link=""/>
			<team fullname="Samoa " phrase="Samoa " searchterms="" link=""/>
			<team fullname="Fiji" phrase="Fiji" searchterms="" link=""/>
			<team fullname="United States " phrase="United States " searchterms="" link=""/>
			<team fullname="Japan " phrase="Japan " searchterms="" link=""/>
			<team fullname="Russia " phrase="Russia " searchterms="" link=""/>
			<team fullname="Georgia " phrase="Georgia " searchterms="" link=""/>
			<team fullname="Lebanon " phrase="Lebanon " searchterms="" link=""/>
		</competition>
		
		<competition sport="Rugby league" converted="rugbyleague" name="Australian" phrase="Australian"/>
		
		<competition sport="Rugby league" converted="rugbyleague" name="COMPETITIONS" phrase="Competitions" hidefromteam="yes" hide="yes">
			<team fullname="Super League" phrase="Super League" searchterms="" link=""/>
			<team fullname="European Nations" phrase="European Nations" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby league" converted="rugbyleague" name="COMPETITIONS 2" phrase="Competitions 2" hidefromteam="yes" hide="yes">
			<team fullname="Tri Nations" phrase="Tri Nations" searchterms="" link=""/>
			<team fullname="World Cup" phrase="World Cup" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby league" converted="rugbyleague" name="COMPETITIONS 3" phrase="Competitions 3" hidefromteam="yes" hide="yes">
			<team fullname="Challenge Cup" phrase="Challenge Cup" searchterms="" link=""/>
			<team fullname="Australian" phrase="Australian" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby league" converted="rugbyleague" name="COMPETITIONS 4" phrase="Competitions 4" hidefromteam="yes" hide="yes">
			<team fullname="Arriva Trains" phrase="Arriva Trains" searchterms="" link=""/>
			<team fullname="National League" phrase="National League" searchterms="" link=""/>
		</competition>

		<competition sport="Rugby league" converted="rugbyleague" name="NRL" phrase="NRL" searchterms="" link="" hide="yes">
			<team fullname="Brisbane " phrase="Brisbane " searchterms="" link=""/>
			<team fullname="Canberra" phrase="Canberra" searchterms="" link=""/>
			<team fullname="Canterbury" phrase="Canterbury" searchterms="" link=""/>
			<team fullname="Cronulla" phrase="Cronulla" searchterms="" link=""/>
			<team fullname="Gold Coast" phrase="Gold Coast" searchterms="" link=""/>
			<team fullname="Manly" phrase="Manly" searchterms="" link=""/>
			<team fullname="Melbourne" phrase="Melbourne" searchterms="" link=""/>
			<team fullname="Newcastle" phrase="Newcastle" searchterms="" link=""/>
			<team fullname="New Zealand Warriors" phrase="New Zealand Warriors" searchterms="" link=""/>
                        <team fullname="North Queensland" phrase="North Queensland" searchterms="" link=""/>
			<team fullname="Parramatta" phrase="Parramatta" searchterms="" link=""/>
			<team fullname="Penrith" phrase="Penrith" searchterms="" link=""/>
			<team fullname="St George/Illawarra" phrase="St George/Illawarra" searchterms="" link=""/>
			<team fullname="South Sydney" phrase="South Sydney" searchterms="" link=""/>
                        <team fullname="Sydney" phrase="Sydney" searchterms="" link=""/>
			<team fullname="Wests" phrase="Wests" searchterms="" link=""/>
		</competition>
		<competition sport="Rugby league" converted="rugbyleague" name="Origin" phrase="Origin" searchterms="" link="" hide="yes">
			<team fullname="New South Wales" phrase="New South Wales" searchterms="" link=""/>
			<team fullname="Queensland" phrase="Queensland" searchterms="" link=""/>
		</competition>
				
		<competition sport="Rugby league" converted="rugbyleague" name="Challenge Cup" phrase="Challenge Cup"/>
		<competition sport="Rugby league" converted="rugbyleague" name="Tri Nations" phrase="Tri Nations"/>
		<competition sport="Rugby league" converted="rugbyleague" name="World Cup" phrase="World Cup"/>
		<competition sport="Rugby league" converted="rugbyleague" name="European Nations" phrase="European Nations"/>
		<competition sport="Rugby league" converted="rugbyleague" name="State of Origin" phrase="State of Origin"/>
		<competition sport="Rugby league" converted="rugbyleague" name="Arriva Trains" phrase="Arriva Trains"/>
		
		<!-- Tennis -->
		<competition sport="Tennis" converted="tennis" name="Wimbledon" phrase="Wimbledon"/>
		<competition sport="Tennis" converted="tennis" name="Australian Open" phrase="Australian Open"/>
		<competition sport="Tennis" converted="tennis" name="US Open" phrase="US Open"/>
		<competition sport="Tennis" converted="tennis" name="French Open" phrase="French Open"/>
		<competition sport="Tennis" converted="tennis" name="Davis Cup" phrase="Davis Cup"/>
		<competition sport="Tennis" converted="tennis" name="Masters Series" phrase="Masters Series"/>
		<competition sport="Tennis" converted="tennis" name="Fed Cup" phrase="Fed Cup"/>
		<competition sport="Tennis" converted="tennis" name="British Tennis" phrase="British Tennis"/>

		<!-- Golf -->
		<competition sport="Golf" converted="golf" name="Masters" phrase="Masters"/>
		<competition sport="Golf" converted="golf" name="The Open" phrase="The Open"/>
		<competition sport="Golf" converted="golf" name="US Open" phrase="US Open"/>
		<competition sport="Golf" converted="golf" name="US PGA" phrase="US PGA"/>
		<competition sport="Golf" converted="golf" name="Ryder Cup" phrase="Ryder Cup"/>
		<competition sport="Golf" converted="golf" name="PGA Tour" phrase="PGA Tour"/>
		<competition sport="Golf" converted="golf" name="European Tour" phrase="European Tour"/>
		<competition sport="Golf" converted="golf" name="LPGA Tour" phrase="LPGA Tour"/>
		<competition sport="Golf" converted="golf" name="Solheim Cup" phrase="Solheim Cup"/>

		<!-- Motorsport -->
		<competition sport="Motorsport" converted="motorsport" name="Formula One" phrase="Formula One"/>
		<competition sport="Motorsport" converted="motorsport" name="Rallying" phrase="Rallying"/>
		<competition sport="Motorsport" converted="motorsport" name="Motorbikes" phrase="Motorbikes"/>
		<competition sport="Motorsport" converted="motorsport" name="Moto GP" phrase="Moto GP"/>
		<competition sport="Motorsport" converted="motorsport" name="Superbikes" phrase="Superbikes"/>
		<competition sport="Motorsport" converted="motorsport" name="World Rally Championship" phrase="World Rally Championship"/>
		<competition sport="Motorsport" converted="motorsport" name="British Rally Championship" phrase="British Rally Championship"/>
		<competition sport="Motorsport" converted="motorsport" name="A1GP" phrase="A1GP"/>
		<competition sport="Motorsport" converted="motorsport" name="Speedway" phrase="Speedway"/>

		<!-- Boxing -->
		<competition sport="Boxing" converted="boxing" name="Heavy" phrase="Heavy"/>
		<competition sport="Boxing" converted="boxing" name="Cruiser" phrase="Cruiser"/>
		<competition sport="Boxing" converted="boxing" name="Light heavy" phrase="Light heavy"/>
		<competition sport="Boxing" converted="boxing" name="Super middle" phrase="Super middle"/>
		<competition sport="Boxing" converted="boxing" name="Middle" phrase="Middle"/>
		<competition sport="Boxing" converted="boxing" name="Light middle" phrase="Light middle"/>
		<competition sport="Boxing" converted="boxing" name="Welter" phrase="Welter"/>
		<competition sport="Boxing" converted="boxing" name="Light welter" phrase="Light welter"/>
		<competition sport="Boxing" converted="boxing" name="Light" phrase="Light"/>
		<competition sport="Boxing" converted="boxing" name="Super feather" phrase="Super feather"/>
		<competition sport="Boxing" converted="boxing" name="Feather" phrase="Feather"/>
		<competition sport="Boxing" converted="boxing" name="Super bantam" phrase="Super bantam"/>
		<competition sport="Boxing" converted="boxing" name="Bantam" phrase="Bantam"/>
		<competition sport="Boxing" converted="boxing" name="Super fly" phrase="Super fly"/>
		<competition sport="Boxing" converted="boxing" name="Fly" phrase="Fly"/>
		<competition sport="Boxing" converted="boxing" name="Light fly" phrase="Light fly"/>
		<competition sport="Boxing" converted="boxing" name="Straw" phrase="Straw"/>
		<competition sport="Boxing" converted="boxing" name="Amateur" phrase="Amateur"/>
		<competition sport="Boxing" converted="boxing" name="Olympics" phrase="Olympics"/>
		<competition sport="Boxing" converted="boxing" name="Legends" phrase="Legends"/>
		<competition sport="Boxing" converted="boxing" name="Pound for pound" phrase="Pound for pound"/>

		<!-- Athletics -->		
		<competition sport="Athletics" converted="athletics" name="British athletics" phrase="British athletics"/>
		<competition sport="Athletics" converted="athletics" name="International athletics" phrase="International athletics"/>
		<competition sport="Athletics" converted="athletics" name="Olympics" phrase="Olympics"/>
		<competition sport="Athletics" converted="athletics" name="London Marathon" phrase="London Marathon"/>
		
		<!-- Snooker -->
		<competition sport="Snooker" converted="snooker" name="Grand Prix" phrase="Grand Prix"/>
		<competition sport="Snooker" converted="snooker" name="Masters" phrase="Masters"/>
		<competition sport="Snooker" converted="snooker" name="UK Championship" phrase="UK Championship"/>
		<competition sport="Snooker" converted="snooker" name="World Championship" phrase="World Championship"/>
		
		<!-- Horse racing -->
		<competition sport="Horse racing" converted="horseracing" name="National Hunt" phrase="National Hunt"/>
		<competition sport="Horse racing" converted="horseracing" name="Flat racing" phrase="Flat racing"/>
		<competition sport="Horse racing" converted="horseracing" name="Grand National" phrase="Grand National"/>
		<competition sport="Horse racing" converted="horseracing" name="Epsom Derby" phrase="Epsom Derby"/>
		<competition sport="Horse racing" converted="horseracing" name="Royal Ascot" phrase="Royal Ascot"/>

		<!-- Cycling -->
		<competition sport="Cycling" converted="cycling" name="Tour de France" phrase="Tour de France"/>
		<competition sport="Cycling" converted="cycling" name="Road cycling" phrase="Road cycling"/>
		<competition sport="Cycling" converted="cycling" name="Track cycling" phrase="Track cycling"/>
		<competition sport="Cycling" converted="cycling" name="Mountain biking" phrase="Mountain biking"/>
		<competition sport="Cycling" converted="cycling" name="BMX" phrase="BMX"/>
		<competition sport="Cycling" converted="cycling" name="Olympics" phrase="Olympics"/>

	</xsl:variable>


	<!-- NEW 606 BROSE PAGE LOOKUPS -->
	<!-- 
	     have decided to split up the browse list lookups into seperate variable for each page
	     to save manipulating a very large msxsl:node-set all over the place
	-->
	
	<xsl:variable name="otherSportsBrowseData">
		<browsepage>
			<group name="ATHLETICS" phrase="Athletics" sport="Athletics">
				<link phrase="British athletics">British athletics</link>
				<link phrase="International athletics">International athletics</link>
				<link phrase="Olympics">Olympics</link>
				<link phrase="London Marathon">London Marathon</link>
				<link phrase="World Championships">World Championships</link>
				<link phrase="Amateur athletics">Amateur athletics</link>
				<link phrase="Junior athletics">Junior athletics</link>
			</group>
			<group name="BOXING" phrase="Boxing" sport="Boxing">
				<link phrase="Heavy weight">Heavy weight</link>
				<link phrase="Cruiser weight">Cruiser weight</link>
				<link phrase="Light heavy weight">Light heavy weight</link>
				<link phrase="Super middle weight">Super middle weight</link>
				<link phrase="Middle weight">Middle weight</link>
				<link phrase="Light middle weight">Light middle weight</link>
				<link phrase="Welter weight">Welter weight</link>
				<link phrase="Light welter weight">Light welter weight</link>
				<link phrase="Light weight">Light weight</link>
				<link phrase="Super feather weight">Super feather weight</link>
				<link phrase="Feather weight">Feather weight</link>
				<link phrase="Super bantam weight">Super bantam weight</link>
				<link phrase="Bantam weight">Bantam weight</link>
				<link phrase="Super fly weight">Super fly weight</link>
				<link phrase="Fly weight">Fly weight</link>
				<link phrase="Light flyweight">Light flyweight</link>
				<link phrase="Straw weight">Straw weight</link>
				<link phrase="Amateur boxing">Amateur boxing</link>
				<link phrase="Olympics">Olympics</link>
			</group>
			<group name="CYCLING" phrase="Cycling" sport="Cycling">
				<link phrase="Tour de France">Tour de France</link>
				<link phrase="International road racing">International road racing</link>
				<link phrase="British road racing">British road racing</link>
				<link phrase="Track cycling">Track cycling</link>
				<link phrase="Mountain biking">Mountain biking</link>
				<link phrase="BMX">BMX</link>
				<link phrase="Olympics">Olympics</link>
				<link phrase="Amateur cycling">Amateur cycling</link>
				<link phrase="Junior cycling">Junior cycling</link>
			</group>
			<group name="GOLF" phrase="Golf" sport="Golf">
				<link phrase="Masters">Masters</link>
				<link phrase="The Open">The Open</link>
				<link phrase="US Open">US Open</link>
				<link phrase="US PGA">US PGA</link>
				<link phrase="Ryder Cup">Ryder Cup</link>
				<link phrase="PGA Tour">PGA Tour</link>
				<link phrase="European Tour">European Tour</link>
				<link phrase="LPGA Tour">LPGA Tour</link>
				<link phrase="Solheim Cup">Solheim Cup</link>
				<link phrase="Amateur golf">Amateur golf</link>
				<link phrase="Junior golf">Junior golf</link>
			</group>
			<group name="HORSE RACING" phrase="Horse Racing" sport="Horse Racing">
				<link phrase="National Hunt">National Hunt</link>
				<link phrase="Flat racing">Flat racing</link>
				<link phrase="Grand National">Grand National</link>
				<link phrase="Epsom Derby">Epsom Derby</link>
				<link phrase="Royal Ascot">Royal Ascot</link>
				<link phrase="Cheltenham">Cheltenham</link>
			</group>
			<group name="MOTORSPORT" phrase="Motorsport" sport="Motorsport">
				<link phrase="Formula One">Formula One</link>
				<link phrase="Rallying">Rallying</link>
				<link phrase="Motorbikes">Motorbikes</link>
				<link phrase="Moto GP">Moto GP</link>
				<link phrase="Superbikes">Superbikes</link>
				<link phrase="World Rally Championship">World Rally Championship</link>
				<link phrase="British Rally Championship">British Rally Championship</link>
				<link phrase="A1GP">A1GP</link>
				<link phrase="Speedway">Speedway</link>
				<link phrase="British Touring Cars">British Touring Cars</link>
				<link phrase="World Touring Cars">World Touring Cars</link>
				<link phrase="Sportscars">Sportscars</link>
				<link phrase="US racing">US racing</link>
				<link phrase="British motorsport">British motorsport</link>
				<link phrase="International motorsport">International motorsport</link>
				<link phrase="BMW Sauber">BMW Sauber</link>
				<link phrase="Ferrari">Ferrari</link>
				<link phrase="Honda">Honda</link>
				<link phrase="Red Bull">Red Bull</link>
				<link phrase="Renault">Renault</link>
				<link phrase="Spyker">Spyker</link>
				<link phrase="Super Aguri">Super Aguri</link>
				<link phrase="Toro Rosso">Toro Rosso</link>
				<link phrase="Toyota">Toyota</link>
				<link phrase="Williams">Williams</link>
			</group>
			<group name="SNOOKER" phrase="Snooker" sport="Snooker">
				<link phrase="Grand Prix">Grand Prix</link>
				<link phrase="Masters">Masters</link>
				<link phrase="UK Championship">UK Championship</link>
				<link phrase="World Championship">World Championship</link>
				<link phrase="Amateur snooker">Amateur snooker</link>
				<link phrase="Junior snooker">Junior snooker</link>
			</group>
			<group name="TENNIS" phrase="Tennis" sport="Tennis">
				<link phrase="Wimbledon">Wimbledon</link>
				<link phrase="Australian Open">Australian Open</link>
				<link phrase="US Open">US Open</link>
				<link phrase="French Open">French Open</link>
				<link phrase="Davis Cup">Davis Cup</link>
				<link phrase="Masters Series">Masters Series</link>
				<link phrase="Fed Cup">Fed Cup</link>
				<link phrase="British tennis">British tennis</link>
				<link phrase="Amateur tennis">Amateur tennis</link>
				<link phrase="Junior tennis">Junior tennis</link>
			</group>
			<group name="OLYMPIC SPORTS" phrase="Olympic Sport">
				<link phrase="Archery">Archery</link>
				<link phrase="Athletics">Athletics</link>
				<link phrase="Badminton">Badminton</link>
				<link phrase="Baseball">Baseball</link>
				<link phrase="Basketball">Basketball</link>
				<link phrase="Boxing">Boxing</link>
				<link phrase="Canoeing">Canoeing</link>
				<link phrase="Cycling">Cycling</link>
				<link phrase="Equestrian">Equestrian</link>
				<link phrase="Fencing">Fencing</link>
				<link phrase="Football">Football</link>
				<link phrase="Gymnastics">Gymnastics</link>
				<link phrase="Handball">Handball</link>
				<link phrase="Hockey">Hockey</link>
				<link phrase="Martial Arts">Martial Arts</link>
				<link phrase="Modern Pentathlon">Modern Pentathlon</link>
				<link phrase="Rowing">Rowing</link>
				<link phrase="Sailing">Sailing</link>
				<link phrase="Shooting">Shooting</link>
				<link phrase="Softball">Softball</link>
				<link phrase="Swimming">Swimming</link>
				<link phrase="TableTennis">Table Tennis</link>
				<link phrase="Tennis">Tennis</link>
				<link phrase="Triathlon">Triathlon</link>
				<link phrase="Volleyball">Volleyball</link>
				<link phrase="Weightlifting">Weightlifting</link>
				<link phrase="Wrestling">Wrestling</link>
			</group>
			<group name="OTHER SPORTS AND EVENTS" phrase="Other Sports And Events">
				<link phrase="AmericanFootball">American Football</link>
				<link phrase="Australian Rules">Australian Rules</link>
				<link phrase="Bowls">Bowls</link>
				<link phrase="Darts">Darts</link>
				<link phrase="Disability Sport">Disability Sport</link>
				<link phrase="Fishing">Fishing</link>
				<link phrase="Gaelic Games">Gaelic Games</link>
				<link phrase="IceHockey">Ice Hockey</link>
				<link phrase="Netball">Netball</link>
				<link phrase="Sports Gaming">Sports Gaming</link>
				<link phrase="Squash">Squash</link>
				<link phrase="Winter Sports">Winter Sports</link>
			</group>
			<group name="EVENTS AND PROGRAMMES" phrase="Events And Programmes">
				<link phrase="Sports Personality of the Year">Sports Personality of the Year</link>
				<link phrase="Sport Relief">Sport Relief</link>
			</group>
		</browsepage>
	</xsl:variable>
	
	<!-- NEW 606 vars -->
	<xsl:variable name="MasterSports">
		<sports>
			<sport main="yes" phrase="Football" converted="football">
				<name>Football</name>
				<a href="http://news.bbc.co.uk/sport1/hi/football/default.stm">BBC Sport Football</a>
			</sport>
			<sport main="yes" phrase="Cricket" converted="cricket">
				<name>Cricket</name>
				<a href="http://news.bbc.co.uk/sport1/hi/cricket/default.stm">BBC Sport Cricket</a>
			</sport>
			<sport main="yes" phrase="Rugby union" converted="rugbyunion">
				<name>Rugby union</name>
				<a href="http://news.bbc.co.uk/sport1/hi/rugby_union/default.stm">BBC Sport Rugby Union</a>
			</sport>
			<sport main="yes" phrase="Rugby league" converted="rugbyleague">
				<name>Rugby league</name>
				<a href="http://news.bbc.co.uk/sport1/hi/rugby_league/default.stm">BBC Sport Rugby League</a>
			</sport>
			<sport phrase="AmericanFootball" converted="americanfootball">
				<name>American Football</name>
			</sport>
			<sport phrase="Archery" converted="archery">
				<name>Archery</name>
			</sport>
			<sport phrase="Athletics" converted="athletics">
				<name>Athletics</name>
				<a href="http://news.bbc.co.uk/sport1/hi/athletics/default.stm">BBC Sport Athletics</a>
			</sport>
			<sport phrase="Australian Rules" converted="australianrules">
				<name>Australian Rules</name>
			</sport>
			<sport phrase="Badminton" converted="badminton">
				<name>Badminton</name>
			</sport>
			<sport phrase="Baseball" converted="baseball">
				<name>Baseball</name>
			</sport>
			<sport phrase="Basketball" converted="basketball">
				<name>Basketball</name>
			</sport>
			<sport phrase="Bowls" converted="bowls">
				<name>Bowls</name>
			</sport>
			<sport phrase="Boxing" converted="boxing">
				<name>Boxing</name>
				<a href="http://news.bbc.co.uk/sport1/hi/boxing/default.stm">BBC Sport Boxing</a>
			</sport>
			<sport phrase="Canoeing" converted="canoeing">
				<name>Canoeing</name>
			</sport>
			<sport phrase="Cycling" converted="cycling">
				<name>Cycling</name>
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/cycling/default.stm">BBC Sport Cycling</a>
			</sport>
			<sport phrase="Darts" converted="darts">
				<name>Darts</name>
			</sport>
			<sport phrase="Disability Sport" converted="disabilitysport">
				<name>Disability Sport</name>
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/disability_sport/default.stm">BBC Sport Disability Sport</a>
			</sport>
			<sport phrase="Equestrian" converted="equestrian">
				<name>Equestrian</name>
			</sport>
			<sport phrase="Fencing" converted="fencing">
				<name>Fencing</name>
			</sport>
			<sport phrase="Fishing" converted="fishing">
				<name>Fishing</name>
			</sport>
			<sport phrase="Gaelic Games" converted="gaelicgames">
				<name>Gaelic Games</name>
			</sport>
			<sport phrase="Golf" converted="golf">
				<name>Golf</name>
				<a href="http://news.bbc.co.uk/sport1/hi/golf/default.stm">BBC Sport Golf</a>
			</sport>
			<sport phrase="Gymnastics" converted="gymnastics">
				<name>Gymnastics</name>
			</sport>
			<sport phrase="Handball" converted="handball">
				<name>Handball</name>
			</sport>
			<sport phrase="Hockey" converted="hockey">
				<name>Hockey</name>
			</sport>
			<sport phrase="Horse Racing" converted="horseracing">
				<name>Horse Racing</name>
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/horse_racing/default.stm">BBC Sport Horse Racing</a>
			</sport>
			<sport phrase="IceHockey" converted="icehockey">
				<name>Ice Hockey</name>
			</sport>
			<sport phrase="Martial Arts" converted="martialarts">
				<name>Martial Arts</name>
			</sport>
			<sport phrase="Modern Pentathlon" converted="modernpentathlon">
				<name>Modern Pentathlon</name>
			</sport>
			<sport phrase="Motorsport" converted="motorsport">
				<name>Motorsport</name>
				<a href="http://news.bbc.co.uk/sport1/hi/motorsport/default.stm">BBC Sport Motorsport</a>
			</sport>
			<sport phrase="Netball" converted="netball">
				<name>Netball</name>
			</sport>
			<sport phrase="Olympic Sport" searchterms="Olympics" converted="olympicsport">
				<name>Olympic sport</name>
			</sport>
			<sport phrase="Rowing" converted="rowing">
				<name>Rowing</name>
			</sport>
			<sport phrase="Sailing" converted="sailing">
				<name>Sailing</name>
			</sport>
			<sport phrase="Shooting" converted="shooting">
				<name>Shooting</name>
			</sport>
			<sport phrase="Snooker" converted="snooker">
				<name>Snooker</name>
                		<a href="http://news.bbc.co.uk/sport1/hi/other_sports/snooker/default.stm">BBC Sport Snooker</a>
			</sport>
			<sport phrase="Sport Relief" converted="sportrelief">
				<name>Sport Relief</name>
			</sport>
			<sport phrase="Sports Gaming" converted="sportsgaming">
				<name>Sports Gaming</name>
			</sport>
			<sport phrase="Sports Personality of the Year" converted="sportspersonalityoftheyear">
				<name>Sports Personality</name>
			</sport>
			<sport phrase="Squash" converted="squash">
				<name>Squash</name>
			</sport>
			<sport phrase="Swimming" converted="swimming">
				<name>Swimming</name>
			</sport>
			<sport phrase="TableTennis" converted="tabletennis">
				<name>Table Tennis</name>
			</sport>
			<sport phrase="Tennis" converted="tennis">
				<name>Tennis</name>
                		<a href="http://news.bbc.co.uk/sport1/hi/tennis/default.stm">BBC Sport Tennis</a>
			</sport>
			<sport phrase="Triathlon" converted="triathlon">
				<name>Triathlon</name>
			</sport>
			<sport phrase="Volleyball" converted="volleyball">
				<name>Volleyball</name>
			</sport>
			<sport phrase="Weightlifting" converted="weightlifting">
				<name>Weightlifting</name>
			</sport>
			<sport phrase="Winter Sports" converted="wintersports">
				<name>Winter Sports</name>
			</sport>
			<sport phrase="Wrestling" converted="Wrestling">
				<name>Wrestling</name>
			</sport>
			<!--
			<sport phrase="Other Sport" converted="other">
				<name>Other Sport</name>
				<a href="http://news.bbc.co.uk/sport1/hi/other_sports/default.stm">BBC Sport Other Sport</a>
			</sport>
			-->
		</sports>
	</xsl:variable>
	
	<xsl:variable name="searchHints">
		<hint>
			<terms>
				<term>american</term>
				<term>football</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>american football</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=americanfootball">americanfootball</a>".</p>
			</message>
		</hint>
		<hint>
			<terms>
				<term>table</term>
				<term>tennis</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>table tennis</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=tabletennis">tabletennis</a>".</p>
			</message>
		</hint>		
		<hint>
			<terms>
				<term>ice</term>
				<term>hockey</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>ice hockey</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=icehockey">icehockey</a>".</p>
			</message>
		</hint>		
		<hint>
			<terms>
				<term>motor</term>
				<term>sport</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>motor sport</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=motorsport">motorsport</a>".</p>
			</message>
		</hint>		
		<hint>
			<terms>
				<term>weight</term>
				<term>lifting</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>weight lifting</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=weightlifting">weightlifting</a>".</p>
			</message>
		</hint>		
		<hint>
			<terms>
				<term>magners</term>
				<term>league</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>magners league</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=magnersleague">magnersleague</a>".</p>
			</message>
		</hint>		
		<hint>
			<terms>
				<term>queens</term>
				<term>park</term>
				<term>rangers</term>
			</terms>
			<message>
				<p class="searchsuggestion">It appears that you were looking for <strong>queens park rangers</strong> content, please try again using the exact search term "<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=QPR">QPR</a>".</p>
			</message>
		</hint>		
	</xsl:variable>
</xsl:stylesheet>

