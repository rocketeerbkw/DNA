<!DOCTYPE xsl:stylesheet 	[															
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--===============Category numbers=====================-->
	<xsl:variable name="categories">
		<!-- cats -->
		<category name="filmIndexPage">
			<server cnum="54640" name="dev" />
			<server cnum="54725" name="stage" />
			<server cnum="54725" name="live" />
		</category>
		<category name="directoryPage">
			<server cnum="54646" name="dev" />
			<server cnum="54726" name="stage" />
			<server cnum="54726" name="live" />
		</category>
		<category name="magazinePage">
			<server cnum="54792" name="dev" />
			<server cnum="" name="release" />
			<server cnum="55269" name="stage" />
			<server cnum="55350" name="live" />
		</category>

		<!-- top cats level -->
		<category name="byGenrePage">
			<server cnum="54641" name="dev" />
			<server cnum="54727" name="stage" />
			<server cnum="54727" name="live" />
		</category>
		<category name="byRegionPage">
			<server cnum="54642" name="dev" />
			<server cnum="54728" name="stage" />
			<server cnum="54728" name="live" />
		</category>
		<category name="byLengthPage">
			<server cnum="54650" name="dev" />
			<server cnum="54729" name="stage" />
			<server cnum="54729" name="live" />
		</category>
		<category name="membersSpecialismPage">
			<server cnum="54679" name="dev" />
			<server cnum="54751" name="stage" />
			<server cnum="54751" name="live" />
		</category>
		<category name="organizationPage">
			<server cnum="54702" name="dev" />
			<server cnum="54761" name="stage" />
			<server cnum="54761" name="live" />
		</category>
		<category name="membersPlacePage">
			<server cnum="54678" name="dev" />
			<server cnum="54752" name="stage" />
			<server cnum="54752" name="live" />
		</category>
		<category name="membersIndustryPanel">
			<server cnum="54919" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="55809" name="live" />
		</category>

		<!-- films by -->
		<category name="byBritishFilmSeason">
			<server cnum="54924" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="55811" name="live" />
		</category>
		<category name="byThemePage">
			<server cnum="54764" name="dev" />
			<server cnum="55222" name="stage" />
			<server cnum="55266" name="live" />
		</category>
		<category name="byFestivalPage">
			<server cnum="54789" name="dev" />
			<server cnum="55254" name="stage" />
			<server cnum="55296" name="live" />
		</category>
		<category name="byDistributorPage">
			<server cnum="54788" name="dev" />
			<server cnum="55253" name="stage" />
			<server cnum="55295" name="live" />
		</category>
		<category name="byOrganisationPage">
			<server cnum="54702" name="dev" />
			<server cnum="54761" name="stage" />
			<server cnum="54761" name="live" />
		</category>
		<category name="bySchoolsPage">
			<server cnum="54850" name="dev" />
			<server cnum="55755" name="stage" />
			<server cnum="55755" name="live" />
		</category>
		<category name="byCompanyPage">
			<server cnum="54847" name="dev" />
			<server cnum="55756" name="stage" />
			<server cnum="55756" name="live" />
		</category>
		<category name="byLabelPage">
			<server cnum="54853" name="dev" />
			<server cnum="55757" name="stage" />
			<server cnum="55757" name="live" />
		</category>
		<category name="byAccessPage">
			<server cnum="54856" name="dev" />
			<server cnum="55758" name="stage" />
			<server cnum="55758" name="live" />
		</category>
		<category name="bySeries">
			<server cnum="54914" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="byScreenAgency">
			<server cnum="54918" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="55808" name="live" />
		</category>

		<!-- length cats -->
		<category name="length2">
			<server cnum="54652" name="dev" />
			<server cnum="54747" name="stage" />
			<server cnum="54747" name="live" />
		</category>
		<category name="length2_5">
			<server cnum="54653" name="dev" />
			<server cnum="54748" name="stage" />
			<server cnum="54748" name="live" />
		</category>
		<category name="length5_10">
			<server cnum="54654" name="dev" />
			<server cnum="54749" name="stage" />
			<server cnum="54749" name="live" />
		</category>
		<category name="length10_20">
			<server cnum="54655" name="dev" />
			<server cnum="54750" name="stage" />
			<server cnum="54750" name="live" />
		</category>

		<!-- region films -->
		<category name="northeast">
			<server cnum="54657" name="dev" />
			<server cnum="54736" name="stage" />
			<server cnum="54736" name="live" />
		</category>
		<category name="northwest">
			<server cnum="54658" name="dev" />
			<server cnum="54737" name="stage" />
			<server cnum="54737" name="live" />
		</category>
		<category name="wales">
			<server cnum="54660" name="dev" />
			<server cnum="54740" name="stage" />
			<server cnum="54740" name="live" />
		</category>
		<category name="nthireland">
			<server cnum="54659" name="dev" />
			<server cnum="54738" name="stage" />
			<server cnum="54738" name="live" />
		</category>
		<category name="scotland">
			<server cnum="54656" name="dev" />
			<server cnum="54735" name="stage" />
			<server cnum="54735" name="live" />
		</category>
		<category name="eastmidlands">
			<server cnum="54683" name="dev" />
			<server cnum="54742" name="stage" />
			<server cnum="54742" name="live" />
		</category>
		<category name="eastofengland">
			<server cnum="54684" name="dev" />
			<server cnum="54743" name="stage" />
			<server cnum="54743" name="live" />
		</category>
		<category name="london">
			<server cnum="54687" name="dev" />
			<server cnum="54746" name="stage" />
			<server cnum="54746" name="live" />
		</category>
		<category name="southeast">
			<server cnum="54686" name="dev" />
			<server cnum="54745" name="stage" />
			<server cnum="54745" name="live" />
		</category>
		<category name="southwest">
			<server cnum="54685" name="dev" />
			<server cnum="54744" name="stage" />
			<server cnum="54744" name="live" />
		</category>
		<category name="westmidlands">
			<server cnum="54682" name="dev" />
			<server cnum="54741" name="stage" />
			<server cnum="54741" name="live" />
		</category>
		<category name="yorkshirehumber">
			<server cnum="54681" name="dev" />
			<server cnum="54739" name="stage" />
			<server cnum="54739" name="live" />
		</category>

		<!-- genre cats -->
		<category name="genreDrama">
			<server cnum="54644" name="dev" />
			<server cnum="54730" name="stage" />
			<server cnum="54730" name="live" />
		</category>
		<category name="genreComedy">
			<server cnum="54645" name="dev" />
			<server cnum="54731" name="stage" />
			<server cnum="54731" name="live" />
		</category>
		<category name="genreDocumentry">
			<server cnum="54663" name="dev" />
			<server cnum="54732" name="stage" />
			<server cnum="54732" name="live" />
		</category>
		<category name="genreAnimation">
			<server cnum="54664" name="dev" />
			<server cnum="54733" name="stage" />
			<server cnum="54733" name="live" />
		</category>
		<category name="genreExperimental">
			<server cnum="54662" name="dev" />
			<server cnum="54734" name="stage" />
			<server cnum="54734" name="live" />
		</category>
		<category name="genreMusic">
			<server cnum="54787" name="dev" />
			<server cnum="55225" name="stage" />
			<server cnum="55297" name="live" />
		</category>

		<!-- people by place -->
		<category label="North East" name="memberNorthEast">
			<server cnum="54696" name="dev" />
			<server cnum="54754" name="stage" />
			<server cnum="54754" name="live" />
		</category>
		<category label="North West" name="memberNorthWest">
			<server cnum="54871" name="dev" />
			<server cnum="54755" name="stage" />
			<server cnum="54755" name="live" />
		</category>
		<category label="Wales" name="memberWales">
			<server cnum="54690" name="dev" />
			<server cnum="54758" name="stage" />
			<server cnum="54758" name="live" />
		</category>
		<category label="Northern Ireland" name="memberNthireland">
			<server cnum="54872" name="dev" />
			<server cnum="54756" name="stage" />
			<server cnum="54756" name="live" />
		</category>
		<category label="Scotland" name="memberScotland">
			<server cnum="54689" name="dev" />
			<server cnum="54753" name="stage" />
			<server cnum="54753" name="live" />
		</category>
		<category label="East Midlands" name="memberEastMidlands">
			<server cnum="54873" name="dev" />
			<server cnum="54760" name="stage" />
			<server cnum="54760" name="live" />
		</category>
		<category label="East of England" name="memberEastOfEngland">
			<server cnum="54874" name="dev" />
			<server cnum="54762" name="stage" />
			<server cnum="54762" name="live" />
		</category>
		<category label="London" name="memberLondon">
			<server cnum="54688" name="dev" />
			<server cnum="54765" name="stage" />
			<server cnum="54765" name="live" />
		</category>
		<category label="South East" name="memberSouthEast">
			<server cnum="54875" name="dev" />
			<server cnum="54764" name="stage" />
			<server cnum="54764" name="live" />
		</category>
		<category label="South West" name="memberSouthWest">
			<server cnum="54876" name="dev" />
			<server cnum="54763" name="stage" />
			<server cnum="54763" name="live" />
		</category>
		<category label="West Midlands" name="memberWestMidlands">
			<server cnum="54877" name="dev" />
			<server cnum="54759" name="stage" />
			<server cnum="54759" name="live" />
		</category>
		<category label="Yorks &amp; Humber" name="memberYorkshirehumber">
			<server cnum="54878" name="dev" />
			<server cnum="54757" name="stage" />
			<server cnum="54757" name="live" />
		</category>

		<!-- people by specialism -->
		<category label="actor (female)" name="specialismActorFemale">
			<server cnum="54693" name="dev" />
			<server cnum="54766" name="stage" />
			<server cnum="54766" name="live" />
		</category>
		<category label="actor (male)" name="specialismActorMale">
			<server cnum="54879" name="dev" />
			<server cnum="54767" name="stage" />
			<server cnum="54767" name="live" />
		</category>
		<category label="animator" name="specialismAnimator">
			<server cnum="54880" name="dev" />
			<server cnum="54768" name="stage" />
			<server cnum="54768" name="live" />
		</category>
		<category label="art department" name="specialismArtDepartment">
			<server cnum="54881" name="dev" />
			<server cnum="54769" name="stage" />
			<server cnum="54769" name="live" />
		</category>
		<category label="assistant director" name="specialismAssistantDirector">
			<server cnum="54882" name="dev" />
			<server cnum="54770" name="stage" />
			<server cnum="54770" name="live" />
		</category>
		<category label="camera" name="specialismCamera">
			<server cnum="54883" name="dev" />
			<server cnum="54771" name="stage" />
			<server cnum="54771" name="live" />
		</category>
		<category label="casting" name="specialismCasting">
			<server cnum="54884" name="dev" />
			<server cnum="54772" name="stage" />
			<server cnum="54772" name="live" />
		</category>
		<category label="composer" name="specialismComposer">
			<server cnum="54885" name="dev" />
			<server cnum="54781" name="stage" />
			<server cnum="54781" name="live" />
		</category>
		<category label="costume designer" name="specialismCostumeDesigner">
			<server cnum="54886" name="dev" />
			<server cnum="54773" name="stage" />
			<server cnum="54773" name="live" />
		</category>
		<category label="director" name="specialismDirector">
			<server cnum="54887" name="dev" />
			<server cnum="54774" name="stage" />
			<server cnum="54774" name="live" />
		</category>
		<category label="director of
			photography"
			name="specialismDirectorOfPhotography">
			<server cnum="54889" name="dev" />
			<server cnum="54775" name="stage" />
			<server cnum="54775" name="live" />
		</category>
		<category label="editor" name="specialismEditor">
			<server cnum="54890" name="dev" />
			<server cnum="54776" name="stage" />
			<server cnum="54776" name="live" />
		</category>
		<category label="film enthusiast" name="specialismFilmEnthusiast">
			<server cnum="54891" name="dev" />
			<server cnum="54777" name="stage" />
			<server cnum="54777" name="live" />
		</category>
		<category label="gaffer" name="specialismGaffer">
			<server cnum="54892" name="dev" />
			<server cnum="54783" name="stage" />
			<server cnum="54783" name="live" />
		</category>
		<category label="grip" name="specialismGrip">
			<server cnum="54893" name="dev" />
			<server cnum="54784" name="stage" />
			<server cnum="54784" name="live" />
		</category>
		<category label="industry professional"
			name="specialismIndustryProfessional">
			<server cnum="54894" name="dev" />
			<server cnum="54778" name="stage" />
			<server cnum="54778" name="live" />
		</category>
		<category label="location manager" name="specialismLocationManager">
			<server cnum="54895" name="dev" />
			<server cnum="54779" name="stage" />
			<server cnum="54779" name="live" />
		</category>
		<category label="make-up artist" name="specialismMakeupArtist">
			<server cnum="54896" name="dev" />
			<server cnum="54780" name="stage" />
			<server cnum="54780" name="live" />
		</category>
		<category label="post-production" name="specialismPostProduction">
			<server cnum="54897" name="dev" />
			<server cnum="54797" name="stage" />
			<server cnum="54797" name="live" />
		</category>
		<category label="producer" name="specialismProducer">
			<server cnum="54692" name="dev" />
			<server cnum="54782" name="stage" />
			<server cnum="54782" name="live" />
		</category>
		<category label="production assistant" name="specialismProductionAssistant">
			<server cnum="54898" name="dev" />
			<server cnum="54788" name="stage" />
			<server cnum="54788" name="live" />
		</category>
		<category label="production
			co-ordinator"
			name="specialismProductionCoordinator">
			<server cnum="54899" name="dev" />
			<server cnum="54789" name="stage" />
			<server cnum="54789" name="live" />
		</category>
		<category label="production designer" name="specialismProductionDesigner">
			<server cnum="54900" name="dev" />
			<server cnum="54786" name="stage" />
			<server cnum="54786" name="live" />
		</category>
		<category label="production manager" name="specialismProductionManager">
			<server cnum="54901" name="dev" />
			<server cnum="54787" name="stage" />
			<server cnum="54787" name="live" />
		</category>
		<category label="runner" name="specialismRunner">
			<server cnum="54902" name="dev" />
			<server cnum="54790" name="stage" />
			<server cnum="54790" name="live" />
		</category>
		<category label="script editor" name="specialismScriptEditor">
			<server cnum="54903" name="dev" />
			<server cnum="54791" name="stage" />
			<server cnum="54791" name="live" />
		</category>
		<category label="script supervisor" name="specialismScriptSupervisor">
			<server cnum="54904" name="dev" />
			<server cnum="54799" name="stage" />
			<server cnum="54799" name="live" />
		</category>
		<category label="sound designer" name="specialismSoundDesigner">
			<server cnum="54905" name="dev" />
			<server cnum="54792" name="stage" />
			<server cnum="54792" name="live" />
		</category>
		<category label="sound recordist" name="specialismSoundRecordist">
			<server cnum="54906" name="dev" />
			<server cnum="54793" name="stage" />
			<server cnum="54793" name="live" />
		</category>
		<category label="stills photographer" name="specialismStillsPhotographer">
			<server cnum="54907" name="dev" />
			<server cnum="54794" name="stage" />
			<server cnum="54794" name="live" />
		</category>
		<category label="storyboard artist" name="specialismStoryboardArtist">
			<server cnum="54908" name="dev" />
			<server cnum="54796" name="stage" />
			<server cnum="54796" name="live" />
		</category>
		<category label="student" name="specialismStudent">
			<server cnum="54909" name="dev" />
			<server cnum="55116" name="stage" />
			<server cnum="55116" name="live" />
		</category>
		<category label="writer" name="specialismWriter">
			<server cnum="54691" name="dev" />
			<server cnum="54795" name="stage" />
			<server cnum="54795" name="live" />
		</category>

		<!-- themes -->
		<category name="themeAction">
			<server cnum="54765" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeAnimation2D">
			<server cnum="54768" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeAnimation3D">
			<server cnum="54769" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeStopmotion">
			<server cnum="54767" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeBlackComedy">
			<server cnum="54770" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeComedyDrama">
			<server cnum="54771" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeDocuDrama">
			<server cnum="54772" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeExperimentalDrama">
			<server cnum="54773" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeFunnies">
			<server cnum="54774" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeGeneralDrama">
			<server cnum="54775" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeHistorical">
			<server cnum="54776" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeHorror">
			<server cnum="54777" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeInnovative">
			<server cnum="54778" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeLoveHate">
			<server cnum="54779" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeMultimedia">
			<server cnum="54780" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeMusicFilm">
			<server cnum="54781" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeMusicPromo">
			<server cnum="54782" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeParody">
			<server cnum="54783" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeScifi">
			<server cnum="54784" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeSocialDrama">
			<server cnum="54785" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		<category name="themeSuspense">
			<server cnum="54786" name="dev" />
			<server cnum="" name="stage" />
			<server cnum="" name="live" />
		</category>
		
		<!-- genre category -->
		<category name="genre">
			<sub-category label="drama" name="drama">
				<server cnum="54644" name="dev" />
				<server cnum="54730" name="stage" />
				<server cnum="54730" name="live" />
			</sub-category>
			<sub-category label="comedy" name="comedy">
				<server cnum="54645" name="dev" />
				<server cnum="54731" name="stage" />
				<server cnum="54731" name="live" />
			</sub-category>
			<sub-category label="documentary" name="documentary">
				<server cnum="54663" name="dev" />
				<server cnum="54732" name="stage" />
				<server cnum="54732" name="live" />
			</sub-category>
			<sub-category label="animation" name="animation">
				<server cnum="54664" name="dev" />
				<server cnum="54733" name="stage" />
				<server cnum="54733" name="live" />
			</sub-category>
			<sub-category label="experimental" name="experimental">
				<server cnum="54662" name="dev" />
				<server cnum="54734" name="stage" />
				<server cnum="54734" name="live" />
			</sub-category>
			<sub-category label="music" name="music">
				<server cnum="54787" name="dev" />
				<server cnum="55225" name="stage" />
				<server cnum="55297" name="live" />
			</sub-category>
		</category>
		
		<!-- theme category -->
		<category name="theme">
			<sub-category label="A Twist In The Tale" name="aTwistInTheTail">
				<server cnum="54768" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55267" name="live" />
			</sub-category>
			<sub-category label="Addictive Behaviour" name="addictiveBehaviour">
				<server cnum="54769" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55269" name="live" />
			</sub-category>
			<sub-category label="Animal Magnetism" name="animalMagnetism">
				<server cnum="54767" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55270" name="live" />
			</sub-category>
			<sub-category label="Behind Closed Doors" name="behindClosedDoors">
				<server cnum="54770" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55271" name="live" />
			</sub-category>
			<sub-category label="Child's Play" name="childsPlay">
				<server cnum="54771" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55272" name="live" />
			</sub-category>
			<sub-category label="Crimes &amp; Misdemeanours" name="crimesAndMisdemeanours">
				<server cnum="54772" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55273" name="live" />
			</sub-category>
			<sub-category label="Crossing Borders" name="crossingBorders">
				<server cnum="54773" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55274" name="live" />
			</sub-category>
			<sub-category label="Cut 'n' Splice" name="cutNSplice">
				<server cnum="54774" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55267" name="live" />
			</sub-category>
			<sub-category label="Deja View" name="dejaView">
				<server cnum="54775" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55277" name="live" />
			</sub-category>
			<sub-category label="End Of The Road" name="endOfTheRoad">
				<server cnum="54776" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55278" name="live" />
			</sub-category>
			<sub-category label="Eye For An Eye" name="eyeForAnEye">
				<server cnum="54777" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55279" name="live" />
			</sub-category>
			<sub-category label="Head To Head" name="headToHead">
				<server cnum="54778" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55280" name="live" />
			</sub-category>
			<sub-category label="Laugh Out Loud" name="laughOutLoud">
				<server cnum="54779" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55281" name="live" />
			</sub-category>
			<sub-category label="Love/Hate" name="loveHate">
				<server cnum="54780" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55282" name="live" />
			</sub-category>
			<sub-category label="Nine-To-Five" name="nineToFive">
				<server cnum="54781" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55283" name="live" />
			</sub-category>
			<sub-category label="Out Of This World" name="horror">
				<server cnum="54782" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55284" name="live" />
			</sub-category>
			<sub-category label="Outsiders" name="outsiders">
				<server cnum="54783" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55285" name="live" />
			</sub-category>
			<sub-category label="Reflections" name="loveHate">
				<server cnum="54784" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55286" name="live" />
			</sub-category>
			<sub-category label="Strange Happenings" name="strangeHappenings">
				<server cnum="54785" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55287" name="live" />
			</sub-category>
			<sub-category label="Talking Heads" name="talkingHeads">
				<server cnum="54786" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55288" name="live" />
			</sub-category>
			<sub-category label="Techno Babble" name="musicPromo">
				<server cnum="54910" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55289" name="live" />
			</sub-category>
			<sub-category label="Teenage Kicks" name="teenageKicks">
				<server cnum="54911" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55290" name="live" />
			</sub-category>
			<sub-category label="Thrill &amp; Chill" name="thrillAndChill">
				<server cnum="54912" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55291" name="live" />
			</sub-category>
			<sub-category label="Urban Tales" name="musicPromo">
				<server cnum="54913" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55292" name="live" />
			</sub-category>
		</category>
		
		<!-- magazine category -->
		<category name="magazine">
			<sub-category label="interviews" name="interviews">
				<server cnum="54793" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55351" name="live" />
			</sub-category>
			<sub-category label="profiles" name="profiles">
				<server cnum="54795" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55352" name="live" />
			</sub-category>
			<sub-category label="opinions" name="opinions">
				<server cnum="54794" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55353" name="live" />
			</sub-category>
			<sub-category label="director's commentaries"
				name="directorsCommentaries">
				<server cnum="54814" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55354" name="live" />
			</sub-category>
			<sub-category label="festivals and awards" name="festivalsAndAwards">
				<server cnum="54815" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55355" name="live" />
			</sub-category>
			<sub-category label="behind the scenes" name="behindTheScenes">
				<server cnum="54816" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55356" name="live" />
			</sub-category>
			<sub-category label="news" name="news">
				<server cnum="54817" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55357" name="live" />
			</sub-category>
			<sub-category label="video diaries" name="videoDiaries">
				<server cnum="54818" name="dev" />
				<server cnum="" name="stage" />
				<server cnum="55358" name="live" />
			</sub-category>
		</category>
	</xsl:variable>

	<!-- SETTING VARIABLES -->
	<!-- cats -->
	<xsl:variable name="thisCatPage">
		<xsl:value-of select="/H2G2/HIERARCHYDETAILS/@NODEID" />
	</xsl:variable>
	<xsl:variable name="filmIndexPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='filmIndexPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="directoryPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='directoryPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="magazinePage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='magazinePage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- top cats level -->
	<xsl:variable name="byGenrePage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byGenrePage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="byRegionPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byRegionPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="byLengthPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byLengthPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="membersSpecialismPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='membersSpecialismPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="membersIndustryPanel">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='membersIndustryPanel']/server[@name=$server]/@cnum"
		/>
	</xsl:variable>
	<xsl:variable name="organizationPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='organizationPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="membersPlacePage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='membersPlacePage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- films by -->
	<xsl:variable name="byBritishFilmSeason">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byBritishFilmSeason']/server[@name=$server]/@cnum"
		/>
	</xsl:variable>
	<xsl:variable name="byThemePage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byThemePage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="bySeries">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='bySeries']/server[@name=$server]/@cnum"
		/>
	</xsl:variable>
	<xsl:variable name="byFestivalPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byFestivalPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="byDistributorPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byDistributorPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="byOrganisationPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byOrganisationPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="bySchoolsPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='bySchoolsPage']/server[@name=$server]/@cnum"
		/>
	</xsl:variable>
	<xsl:variable name="byScreenAgency">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byScreenAgency']/server[@name=$server]/@cnum"
		/>
	</xsl:variable>
	<xsl:variable name="byCompanyPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byCompanyPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="byLabelPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byLabelPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="byAccessPage">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='byAccessPage']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- users add cats numbers -->
	<xsl:variable name="members_place">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='members_place']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="members_specialism">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='members_specialism']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="userpage_article_number">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID" />
	</xsl:variable>

	<!-- length cats -->
	<xsl:variable name="length2">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='length2']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="length2_5">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='length2_5']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="length5_10">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='length5_10']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="length10_20">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='length10_20']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- region films -->
	<xsl:variable name="northeast">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='northeast']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="northwest">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='northwest']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="wales">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='wales']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="nthireland">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='nthireland']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="scotland">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='scotland']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="eastmidlands">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='eastmidlands']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="eastofengland">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='eastofengland']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="london">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='london']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="southeast">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='southeast']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="southwest">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='southwest']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="westmidlands">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='westmidlands']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="yorkshirehumber">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='yorkshirehumber']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- genre cats -->
	<xsl:variable name="genreDrama">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='genreDrama']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="genreComedy">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='genreComedy']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="genreDocumentry">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='genreDocumentry']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="genreAnimation">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='genreAnimation']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="genreExperimental">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='genreExperimental']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="genreMusic">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='genreMusic']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- people by place -->
	<xsl:variable name="memberNorthEast">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberNorthEast']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberNorthWest">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberNorthWest']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberWales">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberWales']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberNthireland">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberNthireland']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberScotland">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberScotland']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberEastMidlands">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberEastMidlands']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberEastOfEngland">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberEastOfEngland']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberLondon">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberLondon']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberSouthEast">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberSouthEast']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberSouthWest">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberSouthWest']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberWestMidlands">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberWestMidlands']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="memberYorkshirehumber">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='memberYorkshirehumber']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- people by specialism -->
	<xsl:variable name="specialismActorFemale">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismActorFemale']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismActorMale">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismActorMale']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismAnimator">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismAnimator']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismArtDepartment">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismArtDepartment']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismAssistantDirector">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismAssistantDirector']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismCamera">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismCamera']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismCasting">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismCasting']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismComposer">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismComposer']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismCostumeDesigner">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismCostumeDesigner']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismDirector">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismDirector']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismDirectorOfPhotography">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismDirectorOfPhotography']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismEditor">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismEditor']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismFilmEnthusiast">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismFilmEnthusiast']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismGaffer">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismGaffer']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismGrip">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismGrip']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismIndustryProfessional">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismIndustryProfessional']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismLocationManager">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismLocationManager']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismMakeupArtist">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismMakeupArtist']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismPostProduction">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismPostProduction']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismProducer">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismProducer']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismProductionAssistant">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismProductionAssistant']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismProductionCoordinator">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismProductionCoordinator']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismProductionDesigner">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismProductionDesigner']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismProductionManager">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismProductionManager']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismRunner">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismRunner']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismScriptEditor">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismScriptEditor']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismScriptSupervisor">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismScriptSupervisor']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismSoundDesigner">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismSoundDesigner']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismSoundRecordist">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismSoundRecordist']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismStillsPhotographer">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismStillsPhotographer']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismStoryboardArtist">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismStoryboardArtist']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismStudent">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismStudent']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="specialismWriter">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='specialismWriter']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<!-- themes -->
	<xsl:variable name="themeAction">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeAction']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeAnimation2D">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeAnimation2D']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeAnimation3D">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeAnimation3D']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeStopmotion">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeStopmotion']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeBlackComedy">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeBlackComedy']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeComedyDrama">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeComedyDrama']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeDocuDrama">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeDocuDrama']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeExperimentalDrama">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeExperimentalDrama']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeFunnies">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeFunnies']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeGeneralDrama">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeGeneralDrama']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeHistorical">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeHistorical']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeHorror">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeHorror']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeInnovative">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeInnovative']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeLoveHate">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeLoveHate']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeMultimedia">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeMultimedia']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeMusicFilm">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeMusicFilm']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeMusicPromo">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeMusicPromo']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeParody">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeParody']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeScifi">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeScifi']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeSocialDrama">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeSocialDrama']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>
	<xsl:variable name="themeSuspense">
		<xsl:value-of
			select="msxsl:node-set($categories)/category[@name='themeSuspense']/server[@name=$server]/@cnum"
		 />
	</xsl:variable>

	<xsl:variable name="specialism">
		<specialism cnumber="54766" label="actor (female)" />
		<specialism cnumber="54767" label="actor (male)" />
		<specialism cnumber="54768" label="animator" />
		<specialism cnumber="54769" label="art department" />
		<specialism cnumber="54770" label="assistant director" />
		<specialism cnumber="54771" label="camera" />
		<specialism cnumber="54772" label="casting" />
		<specialism cnumber="54781" label="composer" />
		<specialism cnumber="54773" label="costume designer" />
		<specialism cnumber="54774" label="director" />
		<specialism cnumber="54775" label="director of photography" />
		<specialism cnumber="54776" label="editor" />
		<specialism cnumber="54777" label="film enthusiast" />
		<specialism cnumber="54783" label="gaffer" />
		<specialism cnumber="54784" label="grip" />
		<specialism cnumber="54778" label="industry professional" />
		<specialism cnumber="54779" label="location manager" />
		<specialism cnumber="54780" label="makeup artist" />
		<specialism cnumber="54797" label="post-production" />
		<specialism cnumber="54782" label="producer" />
		<specialism cnumber="54788" label="production assistant" />
		<specialism cnumber="54789" label="production co-ordinator" />
		<specialism cnumber="54786" label="production designer" />
		<specialism cnumber="54787" label="production manager" />
		<specialism cnumber="54790" label="runner" />
		<specialism cnumber="54791" label="script editor" />
		<specialism cnumber="54799" label="script supervisor " />
		<specialism cnumber="54792" label="sound designer" />
		<specialism cnumber="54793" label="sound recordist" />
		<specialism cnumber="54794" label="stills photographer" />
		<specialism cnumber="54796" label="storyboard artist" />
		<specialism cnumber="55116" label="student" />
		<specialism cnumber="54795" label="writer" />
	</xsl:variable>

	<xsl:variable name="place">
		<place cnumber="54760" label="East Midlands" />
		<place cnumber="54762" label="East of England" />
		<place cnumber="54765" label="London" />
		<place cnumber="54754" label="North East" />
		<place cnumber="54755" label="North West" />
		<place cnumber="54756" label="Northern Ireland" />
		<place cnumber="54753" label="Scotland" />
		<place cnumber="54764" label="South East" />
		<place cnumber="54763" label="South West" />
		<place cnumber="54758" label="Wales" />
		<place cnumber="54759" label="West Midlands" />
		<place cnumber="54757" label="Yorks &amp; Humber" />
	</xsl:variable>
	
	<!-- template instead of the crappy drop_down javascript madness that was in
		the categories.xsl-->
	<xsl:template name="drop_down">
		<xsl:param name="category" select="'theme'"/>
		<form class="dropdownmenu"
			onsubmit="self.location=this.link.options[this.link.selectedIndex].value; return false;">
			<select class="bannerformobject" name="link">
				<option selected="selected">
					<xsl:text>-select </xsl:text>
					<xsl:choose>
						<xsl:when test="$category = 'theme'">a theme</xsl:when>
						<xsl:when test="$category = 'genre'">a genre</xsl:when>
						<xsl:when test="$category = 'magazine'">other magazine archive</xsl:when>
					</xsl:choose>
				</option>
				<xsl:for-each
					select="msxsl:node-set($categories)/category[@name =
					$category]/sub-category">
					<xsl:sort select="@label" />
					<option value="{$root}C{server[@name = $server]/@cnum}">
						<xsl:value-of select="@label" />
					</option>
				</xsl:for-each>
			</select>
			<input alt="GO" height="19"
				src="{$imagesource}furniture/boxbtn_go.gif"
				type="image" width="27" />
		</form>
	</xsl:template>
	
	<xsl:template name="DROP_DOWN">
		<form class="dropdownmenu"
			onSubmit="self.location=this.link.options[this.link.selectedIndex].value; return false;">
			<xsl:choose>
				<xsl:when
					test="ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage or /H2G2/@TYPE='FRONTPAGE' or /H2G2/@TYPE='FRONTPAGE-EDITOR'">
					<xsl:variable name="dropdownText">
						<xsl:choose>
							<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage">please
								select</xsl:when>
							<xsl:otherwise>- select a theme</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<script type="text/javascript">
					<xsl:choose>
						<xsl:when test="$server = 'dev'">
							document.write('<select class="bannerformobject" name="link"><option selected="selected"><xsl:value-of select="$dropdownText" /></option><option value="{$root}C{$themeAction}">action </option><option value="{$root}C{$themeAnimation2D}">animation 2D traditional</option><option value="{$root}C{$themeAnimation3D}">animation 3D/Computer</option><option value="{$root}C{$themeStopmotion}">animation stop-motion</option><option value="{$root}C{$themeBlackComedy}">black comedy</option><option value="{$root}C{$themeComedyDrama}">comedy drama</option><option value="{$root}C{$themeDocuDrama}">docu drama</option><option value="{$root}C{$themeExperimentalDrama}">experimental drama</option><option value="{$root}C{$themeFunnies}">funnies</option><option value="{$root}C{$themeGeneralDrama}">general drama</option><option value="{$root}C{$themeHistorical}">historical</option><option value="{$root}C{$themeHorror}">horror</option><option value="{$root}C{$themeInnovative}">innovative</option><option value="{$root}C{$themeLoveHate}">love/hate</option><option value="{$root}C{$themeMultimedia}">multi-media</option><option value="{$root}C{$themeMusicFilm}">music film</option><option value="{$root}C{$themeMusicPromo}">music promo</option><option value="{$root}C{$themeParody}">parody</option><option value="{$root}C{$themeScifi}">sci-fi/fantasy</option><option value="{$root}C{$themeSocialDrama}">social drama</option><option value="{$root}C{$themeSuspense}">suspense</option></select><input alt="GO" height="19" src="{$imagesource}furniture/boxbtn_go.gif" type="image" width="27" />');
						</xsl:when>
						<xsl:when test="$server = 'live'">
							document.write('<select class="bannerformobject" name="link"><option selected="selected"><xsl:value-of select="$dropdownText" /></option><option value="{$root}C{55267}">A Twist In The Tale</option><option value="{$root}C{55269}">Addictive Behaviour</option><option value="{$root}C{55270}">Animal Magnetism</option><option value="{$root}C{55271}">Behind Closed Doors</option><option value="{$root}C{55272}">Child\'s Play</option><option value="{$root}C{55273}">Crimes &amp; Misdemeanours</option><option value="{$root}C{55274}">Crossing Borders</option><option value="{$root}C{55276}">Cut \'n\' Splice</option><option value="{$root}C{55277}">Deja View</option><option value="{$root}C{55278}">End Of The Road</option><option value="{$root}C{55279}">Eye For An Eye</option><option value="{$root}C{55280}">Head To Head</option><option value="{$root}C{55281}">Laugh Out Loud</option><option value="{$root}C{55282}">Love/Hate</option><option value="{$root}C{55283}">Nine-To-Five</option><option value="{$root}C{55284}">Out Of This World</option><option value="{$root}C{55285}">Outsiders</option><option value="{$root}C{55286}">Reflections</option><option value="{$root}C{55287}">Strange Happenings</option><option value="{$root}C{55288}">Talking Heads</option><option value="{$root}C{55289}">Techno Babble</option><option value="{$root}C{55290}">Teenage Kicks</option><option value="{$root}C{55291}">Thrill &amp; Chill</option><option value="{$root}C{55292}">Urban Tales</option></select><input alt="GO" height="19" src="{$imagesource}furniture/boxbtn_go.gif" type="image" width="27" />');
						</xsl:when>
					</xsl:choose>
				</script>
					<noscript>
						<a class="rightcol" href="{$root}C{$filmIndexPage}">film categories</a>
						<br />
					</noscript>
				</xsl:when>
				<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byGenrePage">
					<script type="text/javascript">
					document.write('<select class="bannerformobject" name="link"><option selected="selected">please select</option><option value="{$root}C{$genreDrama}">drama</option><option value="{$root}C{$genreComedy}">comedy</option><option value="{$root}C{$genreDocumentry}">documentary</option><option value="{$root}C{$genreAnimation}">animation</option><option value="{$root}C{$genreExperimental}">experimental</option><option value="{$root}C{$genreMusic}">music</option></select><input alt="GO" height="19" src="{$imagesource}furniture/boxbtn_go.gif" type="image" width="27" />');
				</script>
					<noscript>
						<a class="rightcol" href="{$root}C{$filmIndexPage}">film categories</a>
						<br />
					</noscript>
				</xsl:when>
				<xsl:when test="ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage">
					<script type="text/javascript">
					document.write('<select class="bannerformobject" name="link"><option selected="selected">-select other magazine archive</option><option value="{$root}C54793">interviews</option><option value="{$root}C54795">profiles</option><option value="{$root}C54794">opinions</option><option value="{$root}C54814">directors\' commentaries</option><option value="{$root}C54815">festivals and awards</option><option value="{$root}C54816">behind the scenes</option><option value="{$root}C54817">news</option><option value="{$root}C54818">video diaries</option></select><input alt="GO" height="19" src="{$imagesource}furniture/boxbtn_go.gif" type="image" width="27" />');	
				</script>
					<noscript>
						<a class="rightcol" href="{$root}magazine">magazine archive</a>
						<br />
					</noscript>
				</xsl:when>
			</xsl:choose>
		</form>
	</xsl:template>
	
</xsl:stylesheet>
