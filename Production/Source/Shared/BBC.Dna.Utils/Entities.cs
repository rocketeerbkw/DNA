using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna.Utils
{
	/// <summary>
	/// A simple static class to encapsulate the HTML entities we require
	/// </summary>
	public static class Entities
	{
        public static Dictionary<string,string> EntityDictionary = new Dictionary<string,string>()
        {
            {"AElig","&#198;"},
            {"Aacute","&#193;"},
            {"Acirc","&#194;"},
            {"Agrave","&#192;"},
            {"Alpha","&#913;"},
            {"Aring","&#197;"},
            {"Atilde","&#195;"},
            {"Auml","&#196;"} ,
            {"Beta","&#914;"} ,
            {"COPY","&#169;"} ,
            {"Ccedil","&#199;"},
            {"Chi","&#935;"},
            {"Dagger","&#8225;"},
            {"Delta","&#916;"},
            {"ETH","&#208;"},
            {"Eacute","&#201;"},
            {"Ecirc","&#202;"},
            {"Egrave","&#200;"},
            {"Epsilon","&#917;"},
            {"Eta","&#919;"},
            {"Euml","&#203;"} ,
            {"Gamma","&#915;"},
            {"GT","&#62;"},
            {"Iacute","&#205;"},
            {"Icirc","&#206;"},
            {"Igrave","&#204;"},
            {"Iota","&#921;"} ,
            {"Iuml","&#207;"} ,
            {"Kappa","&#922;"},
            {"Lambda","&#923;"},
            {"LT","&amp;#60;"},
            {"Mu","&#924;"},
            {"Ntilde","&#209;"},
            {"Nu","&#925;"},
            {"OElig","&#338;"},
            {"Oacute","&#211;"},
            {"Ocirc","&#212;"},
            {"Ograve","&#210;"},
            {"Omega","&#937;"},
            {"Omicron","&#927;"},
            {"Oslash","&#216;"},
            {"Otilde","&#213;"},
            {"Ouml","&#214;"} ,
            {"QUOT","&#34;"},
            {"Phi","&#934;"},
            {"Pi","&#928;"},
            {"Prime","&#8243;"},
            {"Psi","&#936;"} ,
            {"REG","&#174;"},
            {"Rho","&#929;"},
            {"Scaron","&#352;"},
            {"Sigma","&#931;"},
            {"THORN","&#222;"},
            {"TRADE","&#8482;"},
            {"Tau","&#932;"},
            {"Theta","&#920;"},
            {"Uacute","&#218;"},
            {"Ucirc","&#219;"},
            {"Ugrave","&#217;"},
            {"Upsilon","&#933;"},
            {"Uuml","&#220;"} ,
            {"Xi","&#926;"},
            {"Yacute","&#221;"},
            {"Yuml","&#376;"} ,
            {"Zeta","&#918;"} ,
            {"aacute","&#225;"},
            {"aafs","&#8301;"},
            {"acirc","&#226;"},
            {"acute","&#180;"},
            {"aelig","&#230;"},
            {"agrave","&#224;"},
            {"alefsym","&#8501;"} ,
            {"alpha","&#945;"},
            {"and","&#8743;"} ,
            {"ang","&#8736;"} ,
            {"aring","&#229;"},
            {"ass","&#8299;"},
            {"asymp","&#8776;"},
            {"atilde","&#227;"},
            {"auml","&#228;"} ,
            {"bdquo","&#8222;"},
            {"beta","&#946;"} ,
            {"brvbar","&#166;"},
            {"bull","&#8226;"},
            {"cap","&#8745;"} ,
            {"ccedil","&#231;"},
            {"cedil","&#184;"},
            {"cent","&#162;"} ,
            {"chi","&#967;"},
            {"circ","&#710;"} ,
            {"clubs","&#9827;"},
            {"cong","&#8773;"},
            {"copy","&#169;"} ,
            {"crarr","&#8629;"},
            {"cup","&#8746;"} ,
            {"curren","&#164;"},
            {"dArr","&#8659;"},
            {"dagger","&#8224;"},
            {"darr","&#8595;"},
            {"deg","&#176;"},
            {"delta","&#948;"},
            {"diams","&#9830;"},
            {"divide","&#247;"},
            {"eacute","&#233;"},
            {"ecirc","&#234;"},
            {"egrave","&#232;"},
            {"empty","&#8709;"},
            {"emsp","&#8195;"},
            {"ensp","&#8194;"},
            {"epsilon","&#949;"},
            {"equiv","&#8801;"},
            {"eta","&#951;"},
            {"eth","&#240;"},
            {"euml","&#235;"} ,
            {"euro","&#8364;"} ,
            {"exist","&#8707;"},
            {"fnof","&#402;"} ,
            {"forall","&#8704;"},
            {"frac12","&#189;"},
            {"frac14","&#188;"},
            {"frac34","&#190;"},
            {"frasl","&#8260;"},
            {"gamma","&#947;"},
            {"ge","&#8805;"},
            {"hArr","&#8660;"},
            {"harr","&#8596;"},
            {"hearts","&#9829;"},
            {"hellip","&#8230;"},
            {"iacute","&#237;"},
            {"iafs","&#8300;"},
            {"icirc","&#238;"},
            {"iexcl","&#161;"},
            {"igrave","&#236;"},
            {"image","&#8465;"},
            {"infin","&#8734;"},
            {"int","&#8747;"} ,
            {"iota","&#953;"} ,
            {"iquest","&#191;"},
            {"isin","&#8712;"},
            {"iss","&#8298;"},
            {"iuml","&#239;"} ,
            {"kappa","&#954;"},
            {"lArr","&#8656;"},
            {"lambda","&#955;"},
            {"lang","&#9001;"},
            {"laquo","&#171;"},
            {"larr","&#8592;"},
            {"lceil","&#8968;"},
            {"ldquo","&#8220;"},
            {"le","&#8804;"},
            {"lfloor","&#8970;"},
            {"lowast","&#8727;"},
            {"loz","&#9674;"} ,
            {"lre","&#8234;"},
            {"lrm","&#8206;"} ,
            {"lro","&#8237;"},
            {"lsaquo","&#8249;"},
            {"lsquo","&#8216;"},
            {"macr","&#175;"} ,
            {"mdash","&#8212;"},
            {"micro","&#181;"},
            {"middot","&#183;"},
            {"minus","&#8722;"},
            {"mu","&#956;"},
            {"nabla","&#8711;"},
            {"nads","&#8302;"},
            {"nbsp","&#160;"} ,
            {"ndash","&#8211;"},
            {"ne","&#8800;"},
            {"ni","&#8715;"},
            {"nods","&#8303;"},
            {"not","&#172;"},
            {"notin","&#8713;"},
            {"nsub","&#8836;"},
            {"ntilde","&#241;"},
            {"nu","&#957;"},
            {"oacute","&#243;"},
            {"ocirc","&#244;"},
            {"oelig","&#339;"},
            {"ograve","&#242;"},
            {"oline","&#8254;"},
            {"omega","&#969;"},
            {"omicron","&#959;"},
            {"oplus","&#8853;"},
            {"or","&#8744;"},
            {"ordf","&#170;"} ,
            {"ordm","&#186;"} ,
            {"oslash","&#248;"},
            {"otilde","&#245;"},
            {"otimes","&#8855;"},
            {"ouml","&#246;"} ,
            {"para","&#182;"} ,
            {"part","&#8706;"},
            {"pdf","&#8236;"},
            {"permil","&#8240;"},
            {"perp","&#8869;"},
            {"phi","&#966;"},
            {"pi","&#960;"},
            {"piv","&#982;"},
            {"plusmn","&#177;"},
            {"pound","&#163;"},
            {"prime","&#8242;"},
            {"prod","&#8719;"},
            {"prop","&#8733;"},
            {"psi","&#968;"},
            {"rArr","&#8658;"},
            {"radic","&#8730;"},
            {"rang","&#9002;"},
            {"raquo","&#187;"},
            {"rarr","&#8594;"},
            {"rceil","&#8969;"},
            {"rdquo","&#8221;"},
            {"real","&#8476;"},
            {"reg","&#174;"},
            {"rfloor","&#8971;"},
            {"rho","&#961;"},
            {"rle","&#8235;"},
            {"rlm","&#8207;"} ,
            {"rlo","&#8238;"},
            {"rsaquo","&#8250;"},
            {"rsquo","&#8217;"},
            {"sbquo","&#8218;"},
            {"scaron","&#353;"},
            {"sdot","&#8901;"},
            {"sect","&#167;"} ,
            {"shy","&#173;"},
            {"sigma","&#963;"},
            {"sigmaf","&#962;"},
            {"sim","&#8764;"} ,
            {"spades","&#9824;"},
            {"sub","&#8834;"} ,
            {"sube","&#8838;"},
            {"sum","&#8721;"} ,
            {"sup","&#8835;"} ,
            {"sup1","&#185;"} ,
            {"sup2","&#178;"} ,
            {"sup3","&#179;"} ,
            {"supe","&#8839;"},
            {"szlig","&#223;"},
            {"tau","&#964;"},
            {"there4","&#8756;"},
            {"theta","&#952;"},
            {"thetasym","&#977;"} ,
            {"thinsp","&#8201;"},
            {"thorn","&#254;"},
            {"tilde","&#732;"},
            {"times","&#215;"},
            {"trade","&#8482;"},
            {"uArr","&#8657;"},
            {"uacute","&#250;"},
            {"uarr","&#8593;"},
            {"ucirc","&#251;"},
            {"ugrave","&#249;"},
            {"uml","&#168;"},
            {"upsih","&#978;"},
            {"upsilon","&#965;"},
            {"uuml","&#252;"} ,
            {"weierp","&#8472;"},
            {"xi","&#958;"},
            {"yacute","&#253;"},
            {"yen","&#165;"},
            {"yuml","&#255;"} ,
            {"zeta","&#950;"} ,
            {"zwj","&#8205;"} ,
            {"zwnj","&#8204;"},
            {"zwsp","&#0203;"}
        };


        private static string entities;

		/// <summary>
		/// returns an XML string representing a partial DTD which converts HTML entities into their literal characters
		/// </summary>
		/// <returns>string containing text of the DTD</returns>
		public static string GetEntities()
		{
            if (!String.IsNullOrEmpty(entities))
            {
                return entities;
            }

            entities = @"<!DOCTYPE H2G2 [";
            foreach (var entity in EntityDictionary)
            {
                entities += string.Format("<!ENTITY {0} '{1}'>", entity.Key, entity.Value);
            }

            entities += "]>";

            return entities;

			/*return @"<!DOCTYPE H2G2 [
<!ENTITY AElig '&#198;'>
<!ENTITY Aacute '&#193;'>   
<!ENTITY Acirc '&#194;'>
<!ENTITY Agrave '&#192;'>   
<!ENTITY Alpha '&#913;'>
<!ENTITY Aring '&#197;'>
<!ENTITY Atilde '&#195;'>   
<!ENTITY Auml '&#196;'> 
<!ENTITY Beta '&#914;'> 
<!ENTITY COPY '&#169;'> 
<!ENTITY Ccedil '&#199;'>   
<!ENTITY Chi '&#935;'>  
<!ENTITY Dagger '&#8225;'>  
<!ENTITY Delta '&#916;'>
<!ENTITY ETH '&#208;'>  
<!ENTITY Eacute '&#201;'>   
<!ENTITY Ecirc '&#202;'>
<!ENTITY Egrave '&#200;'>   
<!ENTITY Epsilon '&#917;'>  
<!ENTITY Eta '&#919;'>  
<!ENTITY Euml '&#203;'> 
<!ENTITY Gamma '&#915;'>
<!ENTITY GT '&#62;'>
<!ENTITY Iacute '&#205;'>   
<!ENTITY Icirc '&#206;'>
<!ENTITY Igrave '&#204;'>   
<!ENTITY Iota '&#921;'> 
<!ENTITY Iuml '&#207;'> 
<!ENTITY Kappa '&#922;'>
<!ENTITY Lambda '&#923;'>
<!ENTITY LT '&amp;#60;'>   
<!ENTITY Mu '&#924;'>   
<!ENTITY Ntilde '&#209;'>   
<!ENTITY Nu '&#925;'>   
<!ENTITY OElig '&#338;'>
<!ENTITY Oacute '&#211;'>   
<!ENTITY Ocirc '&#212;'>
<!ENTITY Ograve '&#210;'>   
<!ENTITY Omega '&#937;'>
<!ENTITY Omicron '&#927;'>  
<!ENTITY Oslash '&#216;'>   
<!ENTITY Otilde '&#213;'>   
<!ENTITY Ouml '&#214;'> 
<!ENTITY QUOT '&#34;'>  
<!ENTITY Phi '&#934;'>  
<!ENTITY Pi '&#928;'>   
<!ENTITY Prime '&#8243;'>   
<!ENTITY Psi '&#936;'>    
<!ENTITY REG '&#174;'>  
<!ENTITY Rho '&#929;'>  
<!ENTITY Scaron '&#352;'>   
<!ENTITY Sigma '&#931;'>
<!ENTITY THORN '&#222;'>
<!ENTITY TRADE '&#8482;'>   
<!ENTITY Tau '&#932;'>  
<!ENTITY Theta '&#920;'>
<!ENTITY Uacute '&#218;'>   
<!ENTITY Ucirc '&#219;'>
<!ENTITY Ugrave '&#217;'>   
<!ENTITY Upsilon '&#933;'>  
<!ENTITY Uuml '&#220;'> 
<!ENTITY Xi '&#926;'>   
<!ENTITY Yacute '&#221;'>   
<!ENTITY Yuml '&#376;'> 
<!ENTITY Zeta '&#918;'> 
<!ENTITY aacute '&#225;'>   
<!ENTITY aafs '&#8301;'>
<!ENTITY acirc '&#226;'>
<!ENTITY acute '&#180;'>
<!ENTITY aelig '&#230;'>
<!ENTITY agrave '&#224;'>   
<!ENTITY alefsym '&#8501;'> 
<!ENTITY alpha '&#945;'>
<!ENTITY and '&#8743;'> 
<!ENTITY ang '&#8736;'> 
<!ENTITY aring '&#229;'>
<!ENTITY ass '&#8299;'>
<!ENTITY asymp '&#8776;'>   
<!ENTITY atilde '&#227;'>   
<!ENTITY auml '&#228;'> 
<!ENTITY bdquo '&#8222;'>   
<!ENTITY beta '&#946;'> 
<!ENTITY brvbar '&#166;'>   
<!ENTITY bull '&#8226;'>
<!ENTITY cap '&#8745;'> 
<!ENTITY ccedil '&#231;'>   
<!ENTITY cedil '&#184;'>
<!ENTITY cent '&#162;'> 
<!ENTITY chi '&#967;'>  
<!ENTITY circ '&#710;'> 
<!ENTITY clubs '&#9827;'>   
<!ENTITY cong '&#8773;'>
<!ENTITY copy '&#169;'> 
<!ENTITY crarr '&#8629;'>   
<!ENTITY cup '&#8746;'> 
<!ENTITY curren '&#164;'>   
<!ENTITY dArr '&#8659;'>
<!ENTITY dagger '&#8224;'>  
<!ENTITY darr '&#8595;'>
<!ENTITY deg '&#176;'>  
<!ENTITY delta '&#948;'>
<!ENTITY diams '&#9830;'>   
<!ENTITY divide '&#247;'>   
<!ENTITY eacute '&#233;'>   
<!ENTITY ecirc '&#234;'>
<!ENTITY egrave '&#232;'>   
<!ENTITY empty '&#8709;'>   
<!ENTITY emsp '&#8195;'>
<!ENTITY ensp '&#8194;'>
<!ENTITY epsilon '&#949;'>  
<!ENTITY equiv '&#8801;'>   
<!ENTITY eta '&#951;'>  
<!ENTITY eth '&#240;'>  
<!ENTITY euml '&#235;'> 
<!ENTITY euro '&#8364;'> 
<!ENTITY exist '&#8707;'>   
<!ENTITY fnof '&#402;'> 
<!ENTITY forall '&#8704;'>  
<!ENTITY frac12 '&#189;'>   
<!ENTITY frac14 '&#188;'>   
<!ENTITY frac34 '&#190;'>   
<!ENTITY frasl '&#8260;'>   
<!ENTITY gamma '&#947;'>
<!ENTITY ge '&#8805;'>  
<!ENTITY hArr '&#8660;'>
<!ENTITY harr '&#8596;'>
<!ENTITY hearts '&#9829;'>  
<!ENTITY hellip '&#8230;'>  
<!ENTITY iacute '&#237;'>   
<!ENTITY iafs '&#8300;'>
<!ENTITY icirc '&#238;'>
<!ENTITY iexcl '&#161;'>
<!ENTITY igrave '&#236;'>   
<!ENTITY image '&#8465;'>   
<!ENTITY infin '&#8734;'>   
<!ENTITY int '&#8747;'> 
<!ENTITY iota '&#953;'> 
<!ENTITY iquest '&#191;'>   
<!ENTITY isin '&#8712;'>
<!ENTITY iss '&#8298;'>
<!ENTITY iuml '&#239;'> 
<!ENTITY kappa '&#954;'>
<!ENTITY lArr '&#8656;'>
<!ENTITY lambda '&#955;'>   
<!ENTITY lang '&#9001;'>
<!ENTITY laquo '&#171;'>
<!ENTITY larr '&#8592;'>
<!ENTITY lceil '&#8968;'>   
<!ENTITY ldquo '&#8220;'>   
<!ENTITY le '&#8804;'>  
<!ENTITY lfloor '&#8970;'>  
<!ENTITY lowast '&#8727;'>  
<!ENTITY loz '&#9674;'> 
<!ENTITY lre '&#8234;'>
<!ENTITY lrm '&#8206;'> 
<!ENTITY lro '&#8237;'>
<!ENTITY lsaquo '&#8249;'>  
<!ENTITY lsquo '&#8216;'>   
<!ENTITY macr '&#175;'> 
<!ENTITY mdash '&#8212;'>   
<!ENTITY micro '&#181;'>
<!ENTITY middot '&#183;'>   
<!ENTITY minus '&#8722;'>   
<!ENTITY mu '&#956;'>   
<!ENTITY nabla '&#8711;'>   
<!ENTITY nads '&#8302;'>
<!ENTITY nbsp '&#160;'> 
<!ENTITY ndash '&#8211;'>   
<!ENTITY ne '&#8800;'>  
<!ENTITY ni '&#8715;'>  
<!ENTITY nods '&#8303;'>
<!ENTITY not '&#172;'>  
<!ENTITY notin '&#8713;'>   
<!ENTITY nsub '&#8836;'>
<!ENTITY ntilde '&#241;'>   
<!ENTITY nu '&#957;'>   
<!ENTITY oacute '&#243;'>   
<!ENTITY ocirc '&#244;'>
<!ENTITY oelig '&#339;'>
<!ENTITY ograve '&#242;'>   
<!ENTITY oline '&#8254;'>   
<!ENTITY omega '&#969;'>
<!ENTITY omicron '&#959;'>  
<!ENTITY oplus '&#8853;'>   
<!ENTITY or '&#8744;'>  
<!ENTITY ordf '&#170;'> 
<!ENTITY ordm '&#186;'> 
<!ENTITY oslash '&#248;'>   
<!ENTITY otilde '&#245;'>   
<!ENTITY otimes '&#8855;'>  
<!ENTITY ouml '&#246;'> 
<!ENTITY para '&#182;'> 
<!ENTITY part '&#8706;'>
<!ENTITY pdf '&#8236;'>
<!ENTITY permil '&#8240;'>  
<!ENTITY perp '&#8869;'>
<!ENTITY phi '&#966;'>  
<!ENTITY pi '&#960;'>   
<!ENTITY piv '&#982;'>  
<!ENTITY plusmn '&#177;'>   
<!ENTITY pound '&#163;'>
<!ENTITY prime '&#8242;'>   
<!ENTITY prod '&#8719;'>
<!ENTITY prop '&#8733;'>
<!ENTITY psi '&#968;'>  
<!ENTITY rArr '&#8658;'>
<!ENTITY radic '&#8730;'>   
<!ENTITY rang '&#9002;'>
<!ENTITY raquo '&#187;'>
<!ENTITY rarr '&#8594;'>
<!ENTITY rceil '&#8969;'>   
<!ENTITY rdquo '&#8221;'>   
<!ENTITY real '&#8476;'>
<!ENTITY reg '&#174;'>  
<!ENTITY rfloor '&#8971;'>  
<!ENTITY rho '&#961;'>  
<!ENTITY rle '&#8235;'>
<!ENTITY rlm '&#8207;'> 
<!ENTITY rlo '&#8238;'>
<!ENTITY rsaquo '&#8250;'>  
<!ENTITY rsquo '&#8217;'>   
<!ENTITY sbquo '&#8218;'>   
<!ENTITY scaron '&#353;'>   
<!ENTITY sdot '&#8901;'>
<!ENTITY sect '&#167;'> 
<!ENTITY shy '&#173;'>  
<!ENTITY sigma '&#963;'>
<!ENTITY sigmaf '&#962;'>   
<!ENTITY sim '&#8764;'> 
<!ENTITY spades '&#9824;'>  
<!ENTITY sub '&#8834;'> 
<!ENTITY sube '&#8838;'>
<!ENTITY sum '&#8721;'> 
<!ENTITY sup '&#8835;'> 
<!ENTITY sup1 '&#185;'> 
<!ENTITY sup2 '&#178;'> 
<!ENTITY sup3 '&#179;'> 
<!ENTITY supe '&#8839;'>
<!ENTITY szlig '&#223;'>
<!ENTITY tau '&#964;'>  
<!ENTITY there4 '&#8756;'>  
<!ENTITY theta '&#952;'>
<!ENTITY thetasym '&#977;'> 
<!ENTITY thinsp '&#8201;'>  
<!ENTITY thorn '&#254;'>
<!ENTITY tilde '&#732;'>
<!ENTITY times '&#215;'>
<!ENTITY trade '&#8482;'>   
<!ENTITY uArr '&#8657;'>
<!ENTITY uacute '&#250;'>   
<!ENTITY uarr '&#8593;'>
<!ENTITY ucirc '&#251;'>
<!ENTITY ugrave '&#249;'>   
<!ENTITY uml '&#168;'>  
<!ENTITY upsih '&#978;'>
<!ENTITY upsilon '&#965;'>  
<!ENTITY uuml '&#252;'> 
<!ENTITY weierp '&#8472;'>  
<!ENTITY xi '&#958;'>   
<!ENTITY yacute '&#253;'>   
<!ENTITY yen '&#165;'>  
<!ENTITY yuml '&#255;'> 
<!ENTITY zeta '&#950;'> 
<!ENTITY zwj '&#8205;'> 
<!ENTITY zwnj '&#8204;'>
<!ENTITY zwsp '&#0203;'>
]>";*/

		}

        /// <summary>
        /// Replaces the text representative of an entity with its numeric value
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string ReplaceEntitiesWithNumericValues(string text)
        {
            foreach (var entity in EntityDictionary)
            {
                text = text.Replace("&" + entity.Key, entity.Value);
            }
            return text;
        }
	}
}
