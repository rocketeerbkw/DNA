<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:include href="clients.xsl"/>

	<xsl:variable name="sitedisplayname">Memoryshare</xsl:variable>
	<xsl:variable name="sitename">memoryshare</xsl:variable>
	<xsl:variable name="skinname">memoryshare</xsl:variable>
	<xsl:variable name="sso_serviceid_path">memoryshare</xsl:variable>
	<xsl:variable name="sso_serviceid_link">memoryshare</xsl:variable>
	<xsl:variable name="sso_assets_path">/memoryshare/sso_resources</xsl:variable>
	<xsl:variable name="enable_rss">N</xsl:variable>

	<xsl:variable name="sso_asset_root">
		<xsl:choose>
			<!--
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://bbc.e3hosting.net/memoryshare/sso_resources/</xsl:when>
			-->
			<xsl:when test="/H2G2/SERVERNAME = $staging_server"><xsl:value-of select="$sso_assets"/></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sso_assets"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="host">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">http://dnadev.national.core.bbc.co.uk</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www0.bbc.co.uk</xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="asset_root">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www0.bbc.co.uk/memoryshare/_staging/</xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk/memoryshare/</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="imagesource">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/images/</xsl:when>
			<!--
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://bbc.e3hosting.net/memoryshare/_trans/images/</xsl:when>
			-->
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www0.bbc.co.uk/memoryshare/_staging/images/</xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk/memoryshare/images/</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="flashsource">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/flash/</xsl:when>
			<!--
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://bbc.e3hosting.net/memoryshare/flash/</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">/memoryshare/flash/</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www0.bbc.co.uk/memoryshare/flash/</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/flash/</xsl:when>
			-->
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www0.bbc.co.uk/memoryshare/_staging/flash/</xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk/memoryshare/flash/</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="smileysource" select="'/dnaimages/boards/images/emoticons/'"/>
	<!-- for smileys see: http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html -->
	
	<xsl:variable name="site_number">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[NAME='memoryshare']/@ID" />
	</xsl:variable>
	
	<!--[FXIME: remove]
	<xsl:variable name="articlesearchlink">ArticleSearchPhrase?contenttype=-1&amp;articlesortby=DateUploaded&amp;phrase=</xsl:variable>
	-->
	
	<xsl:variable name="articlesearch">ArticleSearch</xsl:variable>
	
	<xsl:variable name="articlesearchservice">
		<xsl:value-of select="$root"/>
		<xsl:text>ArticleSearch</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="articlesearchbase">
		<xsl:value-of select="$articlesearch"/>
		<xsl:text>?contenttype=-1&amp;phrase=_memory&amp;show=10</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="articlesearchroot">
		<xsl:value-of select="$root"/>
		<xsl:value-of select="$articlesearchbase"/>
	</xsl:variable>
	
	<!-- whether date range searches are allowed in advanced search (yes/no) -->
	<xsl:variable name="advanced_search_daterange">yes</xsl:variable>
	
	<!-- whether embedding is allowed (yes/no) -->
	<xsl:variable name="typedarticle_embed">yes</xsl:variable>
	
	<!-- whether embedding is allowed for admin users only (yes/no) -->
	<xsl:variable name="typedarticle_embed_admin_only">yes</xsl:variable>
	
	<!-- whether embedding is allowed when editing an article (yes/no)
	 	 deprecated, should always be 'no'
	-->
	<xsl:variable name="typedarticle_embed_edit_add">no</xsl:variable>
	
	<!-- whether embedding requires a terms and conditions tickbox (yes/no) -->
	<xsl:variable name="typedarticle_embed_tc">no</xsl:variable>
	
	<!-- whether the edit media asset link shuold be shown (yes/no) -->
	<xsl:variable name="article_edit_media_asset">yes</xsl:variable>
	
	<!-- whether it is possible to complain about a host memory -->
	<xsl:variable name="article_allow_complain_about_host">yes</xsl:variable>
	
	<!-- for embedded mediaassets -->
	<xsl:variable name="youtube_base_url" select="'http://www.youtube.com/v/'"/>
	<xsl:variable name="googlevideo_base_url" select="'http://video.google.com/googleplayer.swf?docId='"/>
	<xsl:variable name="myspacevideo_base_url" select="'http://lads.myspace.com/videos/vplayer.swf'"/>
	
	<!-- whether a visible client tag should be added (yes/no) -->
	<xsl:variable name="typedarticle_visibletag">yes</xsl:variable>
	
	<!-- whether a client client logo should be displayed on a memory (yes/no) -->
	<xsl:variable name="article_show_client_logo">yes</xsl:variable>
	
	<!-- mode to display the browse interface
		 1: drop-downs, no tag cloud
		 2: no drop-downs, with tag cloud
	-->
	<xsl:variable name="articlesearch_browse_mode">2</xsl:variable>
	
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
	
	<xsl:variable name="vanilla_client">memoryshare</xsl:variable>
	<xsl:variable name="client">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_client']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_client']/VALUE"/>
			</xsl:when>
			<xsl:when test="/H2G2/URLSKINNAME">
				<xsl:value-of select="/H2G2/URLSKINNAME"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$vanilla_client"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="keyword_sep_name">comma</xsl:variable>
	<xsl:variable name="keyword_sep_char">,</xsl:variable>
	<xsl:variable name="keyword_sep_char_disp">,<xsl:text> </xsl:text></xsl:variable>
	<xsl:variable name="keyword_sep_char_url_enc">%2C</xsl:variable>
	
	<xsl:variable name="keyword_prefix_prelim">_</xsl:variable>
	<xsl:variable name="keyword_prefix_delim">-</xsl:variable>
	
	<xsl:variable name="client_keyword_prefix" select="concat($keyword_prefix_prelim, 'client', $keyword_prefix_delim)"/>
	
	<xsl:variable name="client_keyword" select="concat($client_keyword_prefix, $client)"/>
	<xsl:variable name="client_visibletag" select="msxsl:node-set($clients)/list/item[client=$client]/visibletag"/>

	<xsl:variable name="vanilla_client_keyword" select="concat($client_keyword_prefix, $vanilla_client)"/>
	
	<xsl:variable name="client_url_param">
		<xsl:choose>
			<xsl:when test="$client=$vanilla_client"></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($client, '/')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="trueroot">/dna/memoryshare/</xsl:variable>
	<xsl:variable name="root">/dna/memoryshare/<xsl:value-of select="$client_url_param"/></xsl:variable>
	<xsl:variable name="feedroot">http://feeds.bbc.co.uk/dna/memoryshare/</xsl:variable>
	
	<xsl:variable name="date_sep">/</xsl:variable>
	
	<!-- where to redirect to for add/edit article thank you page -->
	<xsl:variable name="typedarticle_thankyou_page">
		<xsl:value-of select="$root"/>
		<xsl:text>thankyou</xsl:text>
	</xsl:variable>
	
	
	<!-- for mediaasset stuff -->
	<xsl:variable name="assetlibrary">http://downloads.bbc.co.uk/dnauploads/</xsl:variable>
	<xsl:variable name="libraryurl">
		<xsl:value-of select="concat($assetlibrary,'library/')"/>
	</xsl:variable>
	
	
	<!--===============   SERVER    =====================-->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
	<xsl:variable name="dna_server">http://dnadev.national.bu.bbc.co.uk</xsl:variable>
	
	<xsl:variable name="development_server">OPS-DNA1</xsl:variable>
	<!--[FIXME: temp. swap]
	<xsl:variable name="development_server">NMSDNA0</xsl:variable>
	-->
	<xsl:variable name="staging_server">NMSDNA0</xsl:variable>


	<!-- DATE VARS / TEMPLATES -->
	<!--[FIXME: moved COUNT_UP into util.xsl]
	<xsl:variable name="decades_from_1900">
		<list>
			<xsl:call-template name="COUNT_UP">
				<xsl:with-param name="from" select="1900"/>
				<xsl:with-param name="to" select="/H2G2/DATE/@YEAR"/>
				<xsl:with-param name="inc" select="10"/>
			</xsl:call-template>
		</list>
	</xsl:variable>
	-->
	<xsl:variable name="lastDecade">2020</xsl:variable>
	
	<xsl:variable name="days">
		<list>
			<item>01</item>
			<item>02</item>
			<item>03</item>
			<item>04</item>
			<item>05</item>
			<item>06</item>
			<item>07</item>
			<item>08</item>
			<item>09</item>
			<item>10</item>
			<item>11</item>
			<item>12</item>
			<item>13</item>
			<item>14</item>
			<item>15</item>
			<item>16</item>
			<item>17</item>
			<item>18</item>
			<item>19</item>
			<item>20</item>
			<item>21</item>
			<item>22</item>
			<item>23</item>
			<item>24</item>
			<item>25</item>
			<item>26</item>
			<item>27</item>
			<item>28</item>
			<item>29</item>
			<item>30</item>
			<item>31</item>
		</list>
	</xsl:variable>
	
	<xsl:variable name="months">
		<list>
			<item nn="00" n="0" mm="01" m="1"   days="31" sname="JAN">January</item>
			<item nn="01" n="1" mm="02" m="2"   days="28" sname="FEB">February</item>
			<item nn="02" n="2" mm="03" m="3"   days="31" sname="MAR">March</item>
			<item nn="03" n="3" mm="04" m="4"   days="30" sname="APR">April</item>
			<item nn="04" n="4" mm="05" m="5"   days="31" sname="MAY">May</item>
			<item nn="05" n="5" mm="06" m="6"   days="30" sname="JUN">June</item>
			<item nn="06" n="6" mm="07" m="7"   days="31" sname="JUL">July</item>
			<item nn="07" n="7" mm="08" m="8"   days="31" sname="AUG">August</item>
			<item nn="08" n="8" mm="09" m="9"   days="30" sname="SEP">September</item>
			<item nn="09" n="9" mm="10" m="10"  days="31" sname="OCT">October</item>
			<item nn="10" n="10" mm="11" m="11" days="30" sname="NOV">November</item>
			<item nn="11" n="11" mm="12" m="12" days="31" sname="DEC">December</item>
		</list>
	</xsl:variable>
	
	<xsl:variable name="entity_lookup">
		<list>
			<item code="3A">:</item>
			<item code="20"> </item>
		</list>
	</xsl:variable>
	
	<xsl:variable name="location_keyword_prefix" select="concat($keyword_prefix_prelim, 'location', $keyword_prefix_delim)"/>
	<xsl:variable name="locations">
		<list>
			<item value="null">England</item>
			<item value="Beds Herts Bucks">Beds, Herts &amp; Bucks</item>
			<item value="Berkshire">Berkshire</item>
			<item value="Birmingham">Birmingham</item>
			<item value="Black Country">Black Country</item>
			<item value="Bradford W Yorks">Bradford &amp; W Yorks</item>
			<item value="Bristol">Bristol</item>
			<item value="Cambridgeshire">Cambridgeshire</item>
			<item value="Cornwall">Cornwall</item>
			<item value="Coventry Warks">Coventry &amp; Warks</item>
			<item value="Cumbria">Cumbria</item>
			<item value="Derby">Derby</item>
			<item value="Devon">Devon</item>
			<item value="Dorset">Dorset</item>
			<item value="Essex">Essex</item>
			<item value="Gloucestershire">Gloucestershire</item>
			<item value="Hampshire">Hampshire</item>
			<item value="Hereford Worcs">Hereford &amp; Worcs</item>
			<item value="Humber">Humber</item>
			<item value="Kent">Kent</item>
			<item value="Lancashire">Lancashire</item>
			<item value="Leeds">Leeds</item>
			<item value="Leicester">Leicester</item>
			<item value="Lincolnshire">Lincolnshire</item>
			<item value="Liverpool">Liverpool</item>
			<item value="London">London</item>
			<item value="Manchester">Manchester</item>
			<item value="Norfolk">Norfolk</item>
			<item value="Northamptonshire">Northamptonshire</item>
			<item value="North Yorkshire">North Yorkshire</item>
			<item value="Nottingham">Nottingham</item>
			<item value="Oxford">Oxford</item>
			<item value="Shropshire">Shropshire</item>
			<item value="Somerset">Somerset</item>
			<item value="South Yorkshire">South Yorkshire</item>
			<item value="Stoke Staffs">Stoke &amp; Staffs</item>
			<item value="Suffolk">Suffolk</item>
			<item value="Surrey Sussex">Surrey &amp; Sussex</item>
			<item value="Tees">Tees</item>
			<item value="Tyne">Tyne</item>
			<item value="Wear">Wear</item>
			<item value="Wiltshire">Wiltshire</item>

			<item value="null">Scotland</item>
			<item value="Highlands and Islands">Highlands and Islands</item>
			<item value="North East Scotland">North East Scotland</item>
			<item value="Tayside and Central Scotland">Tayside and Central Scotland</item>
			<item value="Glasgow and West of Scotland">Glasgow and West of Scotland</item>
			<item value="Edinburgh and East of Scotland">Edinburgh and East of Scotland</item>
			<item value="South Scotland">South Scotland</item>

			<item value="null">Wales</item>
			<item value="North East Wales">North East Wales</item>
			<item value="North West Wales">North West Wales</item>
			<item value="Mid Wales">Mid Wales</item>
			<item value="South East Wales">South East Wales</item>
			<item value="South West Wales">South West Wales</item><br />
			<item value="Gogledd Orllewin">Gogledd Orllewin</item>
			<item value="Gogledd Ddwyrain">Gogledd Ddwyrain</item>
			<item value="Canolbarth">Canolbarth</item>
			<item value="De Orllewin">De Orllewin</item>
			<item value="De Ddwyrain">De Ddwyrain</item>

			<item value="null">Channel Islands</item>
			<item value="Guernsey">Guernsey</item>
			<item value="Jersey">Jersey</item>
			<item value="null">Isle of Man</item>
			<item value="Isle of Man">Isle of Man</item>
			<item value="null">Northern Ireland</item>
			<item value="Northern Ireland">Northern Ireland</item>
			
			<item value="_other">None of the above</item>
		</list>
	</xsl:variable>
	
	<xsl:variable name="rss_show">20</xsl:variable>
	<xsl:variable name="rss_param">rss</xsl:variable>
	
	<!-- USER ROLES TESTS -->
	<xsl:variable name="test_IsEditor" select="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR"/>
	<xsl:variable name="test_IsHost" select="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR"/>
	<xsl:variable name="test_IsModerator" select="/H2G2/VIEWING-USER/USER/GROUPS/MODERATOR"/>
	<xsl:variable name="test_IsReferee" select="/H2G2/VIEWING-USER/USER/GROUPS/REFEREE"/>

	<xsl:variable name="test_IsAdminUser" select="$test_IsHost or $test_IsModerator or $test_IsReferee"/>
	
	<xsl:variable name="test_OwnerIsViewer">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='USERPAGE'] and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='MOREPOSTS'] and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/POSTS/@USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='ARTICLE'] and number(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE) = 3 and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='JOURNAL'] and number(/H2G2/JOURNAL/@USERID) = number(/H2G2/VIEWING-USER/USER/USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='CLUB'] and /H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">1</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>
	
	<xsl:variable name="test_AuthorIsHost">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="test_MediaAssetOwnerIsHost" select="/H2G2/MEDIAASSET/OWNER/USER/GROUPS/GROUP[NAME='EDITOR'] or /H2G2/MEDIAASSETINFO/MEDIAASSET/OWNER/USER/GROUPS/GROUP[NAME='EDITOR']"/>
	<xsl:variable name="test_IsCeleb">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/ALTNAME = ''">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>
	
	
</xsl:stylesheet>
