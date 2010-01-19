<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="clients">
		<list>
			<item>
			 	<name>London</name>
			 	<client>london</client>
			 	<visibletag>BBC London</visibletag>
			 	<url>http://www.bbc.co.uk/london/</url>
			 	<logo1>client_logos/bbc_london.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/london/rss/</rsshelp>			 	
			</item>
			<item>
			 	<name>Norfolk</name>
			 	<client>norfolk</client>
			 	<visibletag>BBC Norfolk</visibletag>
			 	<url>http://www.bbc.co.uk/norfolk/</url>
			 	<logo1>client_logos/bbc_norfolk.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/norfolk/rss/</rsshelp>
			</item>
			<item>
			 	<name>South Yorkshire</name>
			 	<client>southyorkshire</client>
			 	<visibletag>BBC South Yorkshire</visibletag>
			 	<url>http://www.bbc.co.uk/southyorkshire/</url>
			 	<logo1>client_logos/bbc_southyorkshire.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Cumbria</name>
			 	<client>cumbria</client>
			 	<visibletag>BBC Cumbria</visibletag>
			 	<url>http://www.bbc.co.uk/cumbria/</url>
			 	<logo1>client_logos/bbc_cumbria.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Liverpool</name>
			 	<client>liverpool</client>
			 	<visibletag>BBC Liverpool</visibletag>
			 	<url>http://www.bbc.co.uk/liverpool/</url>
			 	<logo1>client_logos/bbc_liverpool.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Derby</name>
			 	<client>derby</client>
			 	<visibletag>BBC Derby</visibletag>
			 	<url>http://www.bbc.co.uk/derby/</url>
			 	<logo1>client_logos/bbc_derby.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Lincolnshire</name>
			 	<client>lincolnshire</client>
			 	<visibletag>BBC Lincolnshire</visibletag>
			 	<url>http://www.bbc.co.uk/lincolnshire/</url>
			 	<logo1>client_logos/bbc_lincolnshire.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Isle of Man</name>
			 	<client>isleofman</client>
			 	<visibletag>BBC Isle of Man</visibletag>
			 	<url>http://www.bbc.co.uk/isleofman/</url>
			 	<logo1>client_logos/bbc_isleofman.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Oxford</name>
			 	<client>oxford</client>
			 	<visibletag>BBC Oxford</visibletag>
			 	<url>http://www.bbc.co.uk/oxford/</url>
			 	<logo1>client_logos/bbc_oxford.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Bradford &amp; West Yorkshire</name>
			 	<client>bradford</client>
			 	<visibletag>BBC Bradford &amp; West Yorkshire</visibletag>
			 	<url>http://www.bbc.co.uk/bradford/</url>
			 	<logo1>client_logos/bbc_bradford.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Leeds</name>
			 	<client>leeds</client>
			 	<visibletag>BBC Leeds</visibletag>
			 	<url>http://www.bbc.co.uk/leeds/</url>
			 	<logo1>client_logos/bbc_leeds.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Humber</name>
			 	<client>humber</client>
			 	<visibletag>BBC Humber</visibletag>
			 	<url>http://www.bbc.co.uk/humber/</url>
			 	<logo1>client_logos/bbc_humberside.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Radio 4 - Today</name>
			 	<client>radio4today</client>
			 	<visibletag>BBC Radio 4 - Today</visibletag>
			 	<url>http://www.bbc.co.uk/radio4/today</url>
			 	<logo1>client_logos/r4_today.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Writing the Century</name>
			 	<client>radio4writingthecentury</client>
			 	<visibletag>BBC Radio 4 - Writing the Century</visibletag>
			 	<url>http://www.bbc.co.uk/radio4/arts/writing_the_century.shtml</url>
			 	<logo1>client_logos/r4_writing_century.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>1968</name>
			 	<client>radio4_1968</client>
			 	<visibletag>BBC Radio 4 - 1968</visibletag>
			 	<url>http://www.bbc.co.uk/radio4/</url>
			 	<logo1>client_logos/r4_1968.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Radio 4 - Saturday Live</name>
			 	<client>radio4_saturdaylive</client>
			 	<visibletag>Radio 4 - Saturday Live</visibletag>
			 	<url>http://www.bbc.co.uk/radio4/saturdaylive/saturdaylive.shtml</url>
			 	<logo1>client_logos/saturday_live.png</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Writing the Century</name>
			 	<client>writingthecentury</client>
			 	<visibletag>BBC Radio 4 - Writing the Century</visibletag>
			 	<url>http://www.bbc.co.uk/radio4/arts/writing_the_century.shtml</url>
			 	<logo1>client_logos/r4_writing_century.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>World Service</name>
			 	<client>worldservice</client>
			 	<visibletag>BBC World Service - Free to Speak</visibletag>
			 	<url>http://www.bbc.co.uk/worldservice/</url>
			 	<logo1>client_logos/world_service.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			<item>
			 	<name>Radio 1</name>
			 	<client>radio1</client>
			 	<visibletag>BBC Radio 1</visibletag>
			 	<url>http://www.bbc.co.uk/radio1/</url>
			 	<logo1>client_logos/bbc_radio1.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>BBC Memories</name>
			 	<client>bbcmemories</client>
			 	<visibletag>BBC Memories</visibletag>
			 	<url>http://www.bbc.co.uk/heritage/bbcmemories/</url>
			 	<logo1>client_logos/bbc_memories.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			  <item>
			 	<name>Pop on Trial</name>
			 	<client>popontrial</client>
			 	<visibletag>BBC Pop on Trial</visibletag>
			 	<url>http://www.bbc.co.uk/musictv/popontrial/</url>
			 	<logo1>client_logos/pop_on_trial.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Wales</name>
			 	<client>wales</client>
			 	<visibletag>BBC Wales</visibletag>
			 	<url>http://www.bbc.co.uk/wales/</url>
			 	<logo1>client_logos/bbc_wales.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Timescapes</name>
			 	<client>timescapes</client>
			 	<visibletag>Timescapes</visibletag>
			 	<url>http://www.bbc.co.uk/worldservice/</url>
			 	<logo1>client_logos/timescapes.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>LSBU Sisters and Brothers</name>
			 	<client>lsbu_sistersandbrothers</client>
			 	<visibletag>LSBU Sisters and Brothers</visibletag>
			 	<url>http://www.lsbu.ac.uk/families/brothersandsisters/</url>
			 	<logo1>client_logos/sisters_and_brothers.png</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Radio 2 Life2live 70, Not Out!</name>
			 	<client>life2live</client>
			 	<visibletag>Radio 2 Life2live 70, Not Out!</visibletag>
			 	<url>http://www.bbc.co.uk/radio2/life2live/</url>
			 	<logo1>client_logos/life_2_live.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			<item>
			 	<name>MLA - The People's Record</name>
			 	<client>peoplesrecord</client>
			 	<visibletag>MLA - The People's Record</visibletag>
			 	<url>http://www.mla.gov.uk/programmes/settingthepace/Peoples_Record</url>
			 	<logo1>client_logos/peoples-record.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>testsite</name>
			 	<client>testsite</client>
			 	<visibletag>testsite</visibletag>
			 	<url>http://www.bbc.co.uk/</url>
			 	<logo1>client_logos/memoryshare.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			 <item>
			 	<name>Radio 4 - Man on the Moon</name>
			 	<client>radio4manonthemoon</client>
			 	<visibletag>Radio 4 - Man on the Moon</visibletag>
			 	<url>http://www.bbc.co.uk/radio4/</url>
			 	<logo1>client_logos/memoryshare.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			 </item>
			<item>
			 	<name>Memoryshare</name>
			 	<client>memoryshare</client>
			 	<visibletag>BBC Memoryshare</visibletag>
			 	<url>http://www.bbc.co.uk/memoryshare/</url>
			 	<logo1>client_logos/memoryshare.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
				<featuredinc>/memoryshare/includes/featured.sssi</featuredinc>
			 </item>
			<item>
			 	<name>BBC</name>
			 	<client>england</client>
			 	<visibletag>BBC England</visibletag>
			 	<url>http://www.bbc.co.uk/</url>
			 	<logo1>client_logos/bbc_england.gif</logo1>
			 	<rsshelp>http://www.bbc.co.uk/feedfactory/help.shtml</rsshelp>
			</item>
		</list>
	</xsl:variable>
</xsl:stylesheet>