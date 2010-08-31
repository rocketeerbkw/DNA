using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests.Services.Articles
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class Article_V1
    {
        private const string _schemaArticle = "Dna.Services.Articles\\article.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        private string _skinnedGuideML = @"<br /><br /><br /><br /><p>Tower Bridge, widely regarded as the most glamorous bridge across the Thames, was built because the demand for access across the Thames in <a href=""A6681062"">London</a> far exceeded the capacity of the existing bridges. Increased commercial activity in the East End was creating a need for more vehicles to be able to cross the river, downstream of London Bridge. </p><br /><br /><p>Sheer weight of traffic was causing huge problems, and over a period of 11 years around 30 petitions from public bodies were brought before the authorities. The most common suggestions were the building of a new bridge or the widening of London Bridge, although there was also a proposal for a railway line to be built at the bottom of the river. This would carry a travelling stage with its deck at high water level. Designing a bridge over a busy river with low banks was not going to be an easy task. The reason for the difficulties was that the 'pool' of London (the area between London Bridge and the Tower of London) was heavily used by river traffic, and access had to be maintained. </p><br /><br /><p>The pool has been heavily used since Roman times, because it meant that large ocean-going vessels could simply sail straight up the River Thames and unload their goods directly in the city; there was no need to transfer cargo to small river vessels. The river was a major transport route, and for centuries large ships docked at the wharves here to unload. This allowed their cargo to be distributed using the inland river system, and later, by Victorian canals. Although trade began moving away from the pool around the middle of the 20th Century, at the time, large vessels still needed constant access to the Pool.</p><br /><br /><p>In August 1882 the traffic over London Bridge was counted for two days to work out an average for a 24-hour period. At that time London Bridge was only 54 feet wide, yet was carrying over 22,000 vehicles and over 110,000 pedestrians. A committee was set up to consider the petitions and make a decision. Subways and large paddle ferries were also considered at this time. </p><br /><br /><h3>Decision-making and Design</h3><br /><br /><p>In 1878 the City architect Horace Jones proposed a bascule bridge. 'Bascule' comes from the French for 'see-saw', and a bascule bridge at street-level has two 'leaves' that can be raised on a horizontal axis to let ships pass on the river. Similar to a drawbridge, it works on a pivot with a heavy weight at one end to balance the length (weighing 1000 tons) at the other end. It would mean that steep approaches to the bridge could be avoided. His first design was rejected, but in 1884 his second was approved, and an Act of Parliament was passed in 1885 authorising its building. The Act stipulated an opening central span of 200 feet and headroom of 135 feet when the bridge was open<a href=""#""><span id=""footnote-number""></span></a>. In practice these measurements were exceeded by five feet and six inches respectively. It was to be built in keeping with its surroundings - the Tower of London. The site was chosen because, in an area surrounded by wharves, it was cheaper to build the north side of the crossing in the Tower's ditch than it would have been to buy the land.</p><br /><br /><p>Horace Jones was appointed architect. His original designs were very medieval in influence, with the bascules being raised by chains. The revised design was been jointly presented with John Wolfe-Barry, a civil engineer, and was more influenced by the Victorian Gothic style, possibly because Wolfe-Barry's father had been one of the architects on the Houses of Parliament. The bridge's main towers are similar to those of a medieval Scottish castle and the bascules open like an old castle drawbridge. Many of the decorative elements on the stone faç;ade, and the cast iron work are typical of Victorian Gothic architecture. </p><br /><br /><p>Horace Jones died in 1887, just over a year after building work had begun. The foundations had not been completed, and the architectural designs were still only sketches. His assistant George Stevenson took over, and changed the stonework from red brick to Portland stone and Cornish granite. Stevenson also designed many of the decorative details.</p><br /><br /><p>The bridge was opened to traffic by the Prince of Wales (the future King Edward VII) on 30 June, 1894, on behalf of Queen Victoria. The bridge had required eight years of construction at a cost of just over £1,000,000. The journal <i>The Builder</i> called the bridge '<i>the most monstrous and preposterous architectural sham that we have ever known</i>'.</p><br /><br /><h3>Construction</h3><br /><br /><p>Work was started on the bridge in 1886, with the Prince of Wales laying the foundation stone over a time capsule containing papers and coins. The work was intended to take only three years, but parliament was asked twice for more time. Two piers containing 70,000 tons of concrete were sunk into the river bed to support the weight of the bridge, and it was on these that the towers were built. Because the central area of the river could not be obstructed, the towers were built one at a time. The bascules had to be built in the upright position, including the wood paving.</p><br /><br /><p>The towers are 293 feet tall from the foundations, and are made of a steel frame to support the great weight of the bascules, clothed in stone to fit the stipulation that the bridge harmonised with the Tower of London. They contain lifts and stairs to the two walkways running between the towers. The walkways are 110 feet above the roadway and are held in place by metal girders. They were used to stabilise the bridge, and to give pedestrians a way to cross so that they did not have to wait for the bridge to be lowered before they could cross the Thames. As boats used sails less, and steam more, the bridge took only six minutes to open and close. Most pedestrians simply enjoyed the view while waiting for the bridge to close again. The walkways were closed in 1910 due to lack of use by most pedestrians - they had become home to prostitutes. They stayed closed to the public for over 70 years, although they did house some anti-aircraft guns during World War I, and have since been refurbished and re-opened as part of the visitor attractions for the bridge.</p><br /><br /><p>The two side-spans operate on the suspension principle; the 270-foot long approaches (decks) are hung from curved lattice girders. The girders are attached to the towers at the level of the walkway where they are linked together by a chain - each side anchoring the other. They curve down towards the road, then curve up again, reaching up and over the abutment towers at the shoreline before curving back down to the shore where they are anchored. Each chain that runs between the girders and the bridge weighs about the same as a small elephant, per metre.</p><br /><br /><p>The road has a width of 35 feet, with a 12.5-feet-wide pavement on either side; this makes the bridge 60 feet wide.</p><br /><br /><p>More detailed, technical information about the construction of the bridge can be found <a href=""http://www.hartwell.demon.co.uk/tbpic.htm"" title=""Tower Bridge, London"">here</a>. Despite its appearance, Tower Bridge is a steel bridge, not stone, and is extremely strong. It was originally painted in a chocolate brown colour.</p><br /><br /><h3>Moving the Bascules</h3><br /><br /><p>The bridge has always been operated by hydraulics; originally the two pumping engines were powered by steam engines, and the energy stored in six accumulators, ready for use when needed. One set of engines powered the lifting engines which worked the pistons, cranks and cogs that raised the bridge, to save wear and tear. It lifted in less than one minute to 86 degrees. The south side opened slightly before the north side, as they were controlled seperately. Since 1976 the hydraulics have been powered by oil and electricity, and the bascules now open together.</p><br /><br /><p>When the bridge is shut, and the leaves brought together, two bolts called the 'nose bolts,' carried on each leaf, are locked by hydraulic power into sockets on the other leaf.</p><br /><br /><p>When the bridge needs to rise (this requires 24 hours notice), traffic lights stop the traffic. The road gates close, then the pedestrian gates close. The nose bolts are withdrawn, and the bridge lifts. The bascules only fully open for large ships, or to greet ships of importance. In their first year the bascules were raised 6160 times. Nowadays the bridge lifts around 1000 times a year to allow tall ships, cruise ships, naval vessels and other large craft to pass under, and can open and close in five minutes. The record amount of activity stands at 64 lifts in 24 hours in 1910. </p><br /><br /><h3>Action and Adventure</h3><br /><br /><p>The bridge has been the backdrop for a few exciting events, and has appeared in a number of films. These include <a href=""A636923"">Bridget Jones's Diary</a>, The Mummy II, Spice World<a href=""#""><span id=""footnote-number""></span></a> and <a href=""http://www.imdb.com/title/tt0143145/"">The World is Not Enough</a>.</p><br /><br /><p>During the summer of 1912 the English pilot Frank McClean flew a short pusher biplane up the Thames. He failed to get sufficient height to clear the bridge, so he flew under the walkways. This event was captured by newspaper photographers, and the image became famous. He was not the only one - pilots (deliberately) flew under the walkways in 1973 and in 1978.</p><br /><br /><p>In 1952, a number 78 double-decker bus was unlucky enough to be on the bridge when it opened. Back then, the lights would change to red, the gateman would ring bells to encourage the pedestrians to move off the bridge quickly and close the gates, and the head watchman would order the bridge to lift when it was clear. On this day in December, there was a relief watchman, and something went wrong. Albert Gunton, the driver, saw that the road ahead appeared to be sinking. In fact, his bus was perched on the end of an opening bascule, which was giving the illusion of a sinking road ahead. He realised that he would not be able to stop in time to prevent going into the water, and making a split second decision, decided he would go for it. He accelerated and jumped the three feet gap, landing on the north bascule, which had not started to rise. None of his dozen passengers were seriously hurt, and he received £10 for his bravery. He also appeared later on '<a href=""http://www.whirligig-tv.co.uk/tv/adults/quiz/whatsmyline.htm"">What's My Line?</a>'</p><br /><br /><h3>Tower Bridge Exhibition</h3><br /><br /><p>The exhibition has been running for over 20 years, after a £2.5million conversion to the bridge to allow visits to the walkways and Victorian engine rooms, and to set the exhibition up. Visitors can learn about the history of the bridge and how it was built, visit the walkways and level three of the North Tower, and visit the Victorian engine rooms.</p><br /><br /><h4>How to Get There</h4><br /><br /><p>The nearest underground stations are Tower Hill and London Bridge. By rail it can be reached from London Bridge, Fenchurch Street and Tower Gateway on the Docklands Light Railway. </p><br /><br /><h3>Fascinating Facts</h3><br /><br /><ul><br /><li><br /><p> An account of the bridge written in 1937 tells of a tugboat that stood at anchor, but with steam up and ready to go. The tug was there to go to the assistance of any vessel that was in difficulties and threatening the bridge, and to direct river traffic. The cost of maintenance for the tug was one of the conditions given for the erection of the bridge. In the 40 years it had been open at the time, the tug had hardly been used. In 1944 it was sunk by a V1 rocket which had bounced off the bridge. Unsurprisingly, a replacement was not deemed worthwhile. </p><br /></li><br /><br /><li><br /><p>Tower Bridge was the only bridge downstream of London Bridge until 1991, when the <a href=""A667839"" title=""The Thames River Crossings at Dartford"">Queen Elizabeth II</a> was built at Dartford. It was the last bridge built across the Thames in London before the Millennium Bridge opened, nearly 106 years to the day later<a href=""#""><span id=""footnote-number""></span></a>. </p><br /></li><br /><br /><li><br /><p>Tower Bridge is the only moveable bridge on the River Thames, and is funded by an ancient trust - <a href=""http://www.bridgehousegrants.org.uk/history.htm"">Bridge House Estates</a> - which had been set up to manage London Bridge in the 11th Century. The trust keeps the bridge toll-free for road and river traffic, and is managed by the <a href=""A642944"">Corporation of London</a>, who own and manage it. It is insured by Lloyd's of London on the shipping register as a ship, and for the first 23 years of its life, all staff were ex-sailors and servicemen.</p><br /></li><br /><br /><li><br /><p>Try standing in the middle of the bridge (on the pavement of course!) with one foot on each leaf. Wait for a bus or lorry to pass. Enjoy!</p><br /></li><br /></ul><br /><br /><br /><br /><br /><br /><br /><a href=""http://www.bbc.co.uk/history/programmes/best_buildings/best_buildings_06.shtml"" title=""Britain's Best Buildings"" /><br /><a href=""http://www.bbc.co.uk/london/panoramics/popups/tower_bridge.html"" title=""Panoramic view of Tower Bridge"" /><br /><a href=""http://www.bbc.co.uk/london/travel/travelinfo/ferry_bridge_tunnels.shtml"" title="" Tower Bridge Lifts"" /><br /><a href=""http://www.bbc.co.uk/history/programmes/best_buildings/pano_launch_tower_bridge.shtml"" title=""Tower Bridge Panorama"" /><br /><a href=""http://www.towerbridge.org.uk"" title=""Tower Bridge Exhibition"" /><br /><br /><ol class=""footnotes""><li id=""footnote-""><span>. </span>The closed headroom was 29 feet to cater for the high tide, which could be 25 feet higher than low tide.</li><li id=""footnote-""><span>. </span>Where the Spice Girls jumped across the bridge as it opened in a double decker bus.</li><li id=""footnote-""><span>. </span>The Millennium Bridge only stayed open for three days before closing for 20 months to stop a worrying 'sway'.</li></ol>";
        private string _unskinnedGuideML = @"<BR /><PICTURE embed=""Right"" shadow=""None"" H2G2IMG=""towerbridge.jpg"" ALT=""London's Tower Bridge, in silhouette."" /><BR /><BR /><BR /><P>Tower Bridge, widely regarded as the most glamorous bridge across the Thames, was built because the demand for access across the Thames in <LINK H2G2=""A6681062"">London</LINK> far exceeded the capacity of the existing bridges. Increased commercial activity in the East End was creating a need for more vehicles to be able to cross the river, downstream of London Bridge. </P><BR /><BR /><P>Sheer weight of traffic was causing huge problems, and over a period of 11 years around 30 petitions from public bodies were brought before the authorities. The most common suggestions were the building of a new bridge or the widening of London Bridge, although there was also a proposal for a railway line to be built at the bottom of the river. This would carry a travelling stage with its deck at high water level. Designing a bridge over a busy river with low banks was not going to be an easy task. The reason for the difficulties was that the 'pool' of London (the area between London Bridge and the Tower of London) was heavily used by river traffic, and access had to be maintained. </P><BR /><BR /><P>The pool has been heavily used since Roman times, because it meant that large ocean-going vessels could simply sail straight up the River Thames and unload their goods directly in the city; there was no need to transfer cargo to small river vessels. The river was a major transport route, and for centuries large ships docked at the wharves here to unload. This allowed their cargo to be distributed using the inland river system, and later, by Victorian canals. Although trade began moving away from the pool around the middle of the 20th Century, at the time, large vessels still needed constant access to the Pool.</P><BR /><BR /><P>In August 1882 the traffic over London Bridge was counted for two days to work out an average for a 24-hour period. At that time London Bridge was only 54 feet wide, yet was carrying over 22,000 vehicles and over 110,000 pedestrians. A committee was set up to consider the petitions and make a decision. Subways and large paddle ferries were also considered at this time. </P><BR /><BR /><HEADER>Decision-making and Design</HEADER><BR /><BR /><P>In 1878 the City architect Horace Jones proposed a bascule bridge. 'Bascule' comes from the French for 'see-saw', and a bascule bridge at street-level has two 'leaves' that can be raised on a horizontal axis to let ships pass on the river. Similar to a drawbridge, it works on a pivot with a heavy weight at one end to balance the length (weighing 1000 tons) at the other end. It would mean that steep approaches to the bridge could be avoided. His first design was rejected, but in 1884 his second was approved, and an Act of Parliament was passed in 1885 authorising its building. The Act stipulated an opening central span of 200 feet and headroom of 135 feet when the bridge was open<FOOTNOTE>The closed headroom was 29 feet to cater for the high tide, which could be 25 feet higher than low tide.</FOOTNOTE>. In practice these measurements were exceeded by five feet and six inches respectively. It was to be built in keeping with its surroundings - the Tower of London. The site was chosen because, in an area surrounded by wharves, it was cheaper to build the north side of the crossing in the Tower's ditch than it would have been to buy the land.</P><BR /><BR /><P>Horace Jones was appointed architect. His original designs were very medieval in influence, with the bascules being raised by chains. The revised design was been jointly presented with John Wolfe-Barry, a civil engineer, and was more influenced by the Victorian Gothic style, possibly because Wolfe-Barry's father had been one of the architects on the Houses of Parliament. The bridge's main towers are similar to those of a medieval Scottish castle and the bascules open like an old castle drawbridge. Many of the decorative elements on the stone faç;ade, and the cast iron work are typical of Victorian Gothic architecture. </P><BR /><BR /><P>Horace Jones died in 1887, just over a year after building work had begun. The foundations had not been completed, and the architectural designs were still only sketches. His assistant George Stevenson took over, and changed the stonework from red brick to Portland stone and Cornish granite. Stevenson also designed many of the decorative details.</P><BR /><BR /><P>The bridge was opened to traffic by the Prince of Wales (the future King Edward VII) on 30 June, 1894, on behalf of Queen Victoria. The bridge had required eight years of construction at a cost of just over £1,000,000. The journal <I>The Builder</I> called the bridge '<I>the most monstrous and preposterous architectural sham that we have ever known</I>'.</P><BR /><BR /><HEADER>Construction</HEADER><BR /><BR /><P>Work was started on the bridge in 1886, with the Prince of Wales laying the foundation stone over a time capsule containing papers and coins. The work was intended to take only three years, but parliament was asked twice for more time. Two piers containing 70,000 tons of concrete were sunk into the river bed to support the weight of the bridge, and it was on these that the towers were built. Because the central area of the river could not be obstructed, the towers were built one at a time. The bascules had to be built in the upright position, including the wood paving.</P><BR /><BR /><P>The towers are 293 feet tall from the foundations, and are made of a steel frame to support the great weight of the bascules, clothed in stone to fit the stipulation that the bridge harmonised with the Tower of London. They contain lifts and stairs to the two walkways running between the towers. The walkways are 110 feet above the roadway and are held in place by metal girders. They were used to stabilise the bridge, and to give pedestrians a way to cross so that they did not have to wait for the bridge to be lowered before they could cross the Thames. As boats used sails less, and steam more, the bridge took only six minutes to open and close. Most pedestrians simply enjoyed the view while waiting for the bridge to close again. The walkways were closed in 1910 due to lack of use by most pedestrians - they had become home to prostitutes. They stayed closed to the public for over 70 years, although they did house some anti-aircraft guns during World War I, and have since been refurbished and re-opened as part of the visitor attractions for the bridge.</P><BR /><BR /><P>The two side-spans operate on the suspension principle; the 270-foot long approaches (decks) are hung from curved lattice girders. The girders are attached to the towers at the level of the walkway where they are linked together by a chain - each side anchoring the other. They curve down towards the road, then curve up again, reaching up and over the abutment towers at the shoreline before curving back down to the shore where they are anchored. Each chain that runs between the girders and the bridge weighs about the same as a small elephant, per metre.</P><BR /><BR /><P>The road has a width of 35 feet, with a 12.5-feet-wide pavement on either side; this makes the bridge 60 feet wide.</P><BR /><BR /><P>More detailed, technical information about the construction of the bridge can be found <LINK HREF=""http://www.hartwell.demon.co.uk/tbpic.htm"" TITLE=""Tower Bridge, London"">here</LINK>. Despite its appearance, Tower Bridge is a steel bridge, not stone, and is extremely strong. It was originally painted in a chocolate brown colour.</P><BR /><BR /><HEADER>Moving the Bascules</HEADER><BR /><BR /><P>The bridge has always been operated by hydraulics; originally the two pumping engines were powered by steam engines, and the energy stored in six accumulators, ready for use when needed. One set of engines powered the lifting engines which worked the pistons, cranks and cogs that raised the bridge, to save wear and tear. It lifted in less than one minute to 86 degrees. The south side opened slightly before the north side, as they were controlled seperately. Since 1976 the hydraulics have been powered by oil and electricity, and the bascules now open together.</P><BR /><BR /><P>When the bridge is shut, and the leaves brought together, two bolts called the 'nose bolts,' carried on each leaf, are locked by hydraulic power into sockets on the other leaf.</P><BR /><BR /><P>When the bridge needs to rise (this requires 24 hours notice), traffic lights stop the traffic. The road gates close, then the pedestrian gates close. The nose bolts are withdrawn, and the bridge lifts. The bascules only fully open for large ships, or to greet ships of importance. In their first year the bascules were raised 6160 times. Nowadays the bridge lifts around 1000 times a year to allow tall ships, cruise ships, naval vessels and other large craft to pass under, and can open and close in five minutes. The record amount of activity stands at 64 lifts in 24 hours in 1910. </P><BR /><BR /><HEADER>Action and Adventure</HEADER><BR /><BR /><P>The bridge has been the backdrop for a few exciting events, and has appeared in a number of films. These include <LINK H2G2=""A636923"">Bridget Jones's Diary</LINK>, The Mummy II, Spice World<FOOTNOTE>Where the <LINK H2G2=""A467750"">Spice Girls</LINK> jumped across the bridge as it opened in a double decker bus.</FOOTNOTE> and <LINK HREF=""http://www.imdb.com/title/tt0143145/"">The World is Not Enough</LINK>.</P><BR /><BR /><P>During the summer of 1912 the English pilot Frank McClean flew a short pusher biplane up the Thames. He failed to get sufficient height to clear the bridge, so he flew under the walkways. This event was captured by newspaper photographers, and the image became famous. He was not the only one - pilots (deliberately) flew under the walkways in 1973 and in 1978.</P><BR /><BR /><P>In 1952, a number 78 double-decker bus was unlucky enough to be on the bridge when it opened. Back then, the lights would change to red, the gateman would ring bells to encourage the pedestrians to move off the bridge quickly and close the gates, and the head watchman would order the bridge to lift when it was clear. On this day in December, there was a relief watchman, and something went wrong. Albert Gunton, the driver, saw that the road ahead appeared to be sinking. In fact, his bus was perched on the end of an opening bascule, which was giving the illusion of a sinking road ahead. He realised that he would not be able to stop in time to prevent going into the water, and making a split second decision, decided he would go for it. He accelerated and jumped the three feet gap, landing on the north bascule, which had not started to rise. None of his dozen passengers were seriously hurt, and he received £10 for his bravery. He also appeared later on '<LINK HREF=""http://www.whirligig-tv.co.uk/tv/adults/quiz/whatsmyline.htm"">What's My Line?</LINK>'</P><BR /><BR /><HEADER>Tower Bridge Exhibition</HEADER><BR /><BR /><P>The exhibition has been running for over 20 years, after a £2.5million conversion to the bridge to allow visits to the walkways and Victorian engine rooms, and to set the exhibition up. Visitors can learn about the history of the bridge and how it was built, visit the walkways and level three of the North Tower, and visit the Victorian engine rooms.</P><BR /><BR /><SUBHEADER>How to Get There</SUBHEADER><BR /><BR /><P>The nearest underground stations are Tower Hill and London Bridge. By rail it can be reached from London Bridge, Fenchurch Street and Tower Gateway on the Docklands Light Railway. </P><BR /><BR /><HEADER>Fascinating Facts</HEADER><BR /><BR /><UL><BR /><LI><BR /><P> An account of the bridge written in 1937 tells of a tugboat that stood at anchor, but with steam up and ready to go. The tug was there to go to the assistance of any vessel that was in difficulties and threatening the bridge, and to direct river traffic. The cost of maintenance for the tug was one of the conditions given for the erection of the bridge. In the 40 years it had been open at the time, the tug had hardly been used. In 1944 it was sunk by a V1 rocket which had bounced off the bridge. Unsurprisingly, a replacement was not deemed worthwhile. </P><BR /></LI><BR /><BR /><LI><BR /><P>Tower Bridge was the only bridge downstream of London Bridge until 1991, when the <LINK H2G2=""A667839"" TITLE=""The Thames River Crossings at Dartford"">Queen Elizabeth II</LINK> was built at Dartford. It was the last bridge built across the Thames in London before the Millennium Bridge opened, nearly 106 years to the day later<FOOTNOTE>The Millennium Bridge only stayed open for three days before closing for 20 months to stop a worrying 'sway'.</FOOTNOTE>. </P><BR /></LI><BR /><BR /><LI><BR /><P>Tower Bridge is the only moveable bridge on the River Thames, and is funded by an ancient trust - <LINK HREF=""http://www.bridgehousegrants.org.uk/history.htm"">Bridge House Estates</LINK> - which had been set up to manage London Bridge in the 11th Century. The trust keeps the bridge toll-free for road and river traffic, and is managed by the <LINK H2G2=""A642944"">Corporation of London</LINK>, who own and manage it. It is insured by Lloyd's of London on the shipping register as a ship, and for the first 23 years of its life, all staff were ex-sailors and servicemen.</P><BR /></LI><BR /><BR /><LI><BR /><P>Try standing in the middle of the bridge (on the pavement of course!) with one foot on each leaf. Wait for a bus or lorry to pass. Enjoy!</P><BR /></LI><BR /></UL><BR /><BR /><BR /><BR /><BR /><BR /><BR /><REFERENCES><LINK HREF=""http://www.bbc.co.uk/history/programmes/best_buildings/best_buildings_06.shtml"" TITLE=""Britain's Best Buildings"" /><BR /><LINK HREF=""http://www.bbc.co.uk/london/panoramics/popups/tower_bridge.html"" TITLE=""Panoramic view of Tower Bridge"" /><BR /><LINK HREF=""http://www.bbc.co.uk/london/travel/travelinfo/ferry_bridge_tunnels.shtml"" TITLE="" Tower Bridge Lifts"" /><BR /><LINK HREF=""http://www.bbc.co.uk/history/programmes/best_buildings/pano_launch_tower_bridge.shtml"" TITLE=""Tower Bridge Panorama"" /><BR /><LINK HREF=""http://www.towerbridge.org.uk"" TITLE=""Tower Bridge Exhibition"" /></REFERENCES><BR /><BR />";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("ShutDown Article_V1");
        }


        /// <summary>
        /// Set up function  
        /// </summary>
        [ClassInitialize]
        public static void StartUp(TestContext testContext)
        {
            Console.WriteLine("StartUp Article_V1");
            SnapshotInitialisation.RestoreFromSnapshot();

            SetupFullTextIndex();
            SetupKeyNamedArticles();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public Article_V1()
        {
        }

        /// <summary>
        /// Tests if the article API correctly performs a transform on the GUIDEML, if instructed to do so.
        /// </summary>
        [TestMethod]
        public void GetArticle_WithApplySkin_ReturnsSkinnedXml()
        {
            int articleId = 559;

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?applySkin=true", _sitename, articleId);
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            string bodyContent = xml["article"]["text"]["GUIDE"]["BODY"].InnerXml;

            Assert.AreEqual(_skinnedGuideML, bodyContent);
        }

        /// <summary>
        /// Tests if the article API returns the GUIDEML if instructed to not do a transform
        /// </summary>
        [TestMethod]
        public void GetArticle_WithDoNotApplySkin_ReturnsUnskinnedXml()
        {
            int articleId = 559;

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?applySkin=false", _sitename, articleId);
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            string bodyContent = xml["article"]["text"]["GUIDE"]["BODY"].InnerXml;

            Assert.AreEqual(_unskinnedGuideML, bodyContent);
        }

        /// <summary>
        /// Test CreateArticle method from service
        /// </summary>
        [TestMethod]
        public void GetArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetArticle_ReadOnly_ReturnsValidXml");

            int[] ids = { 559, 586, 630, 649, 667, 883, 937, 964, 1251, 1422, 79526,87130,87310,
                            88274,88319,88373,89804,91298,92369,92440,92495,99119,99452,99524,101755,101782};

            foreach (var id in ids)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validing ID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetArticle_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test CreateRandomArticle method from service
        /// </summary>
        [TestMethod]
        public void GetRandomArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetRandomArticle_ReadOnly_ReturnsValidXml");

            for (int i = 0; i < 50; i++)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Get Random Article");
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/random?type=Edited&format=xml", _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetRandomArticle_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetComingUpArticles method from service
        /// </summary>
        [TestMethod]
        public void GetComingUpArticles_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetComingUpArticles_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/comingup?format=xml", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();


            Console.WriteLine("After GetComingUpArticles_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetMonthlySummary method from service
        /// </summary>
        [TestMethod]
        public void GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound()
        {
            Console.WriteLine("Before GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound");
            ClearArticlesForTheLastMonthForMonthSummaryFail();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/month?format=xml", _sitename);

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MonthSummaryNotFound.ToString(), errorData.Code);

            Console.WriteLine("After GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound");
        }
        /// <summary>
        /// Test GetMonthlySummaryArticles_WithSomeArticles method from service
        /// </summary>
        [TestMethod]
        public void GetMonthlySummaryArticles_WithSomeArticles()
        {
            Console.WriteLine("Before GetMonthlySummaryArticles_WithSomeArticles");

            SetupMonthSummaryArticle();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/month?format=xml", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            Console.WriteLine("After GetMonthlySummaryArticles_WithSomeArticles");
        }

        /// <summary>
        /// Test GetSearchArticles method from service
        /// Needs guide entry cat on smallguide created
        /// </summary>
        [TestMethod]
        public void GetSearchArticles()
        {
            Console.WriteLine("Before GetSearchArticles");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles?querystring=dinosaur&showapproved=1&searchtype=ARTICLE&format=xml", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            Console.WriteLine("After GetSearchArticles");
        }

        /// <summary>
        /// Test ClipArticle method from service
        /// </summary>
        [TestMethod]
        public void ClipArticle()
        {
            Console.WriteLine("Before ClipArticle");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1021825/clip/", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After ClipArticle");
        }

        /// <summary>
        /// Test TryClipArticleTwice method from service
        /// </summary>
        [TestMethod]
        public void TryClipArticleTwice()
        {
            Console.WriteLine("Before TryClipArticleTwice");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1422/clip/", _sitename);

            request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");

            try
            {
                request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.AlreadyLinked.ToString(), errorData.Code);


            Console.WriteLine("After TryClipArticleTwice");
        }

        [TestMethod]
        public void ClipArticle_UnknownSite_Returns404()
        {
            Console.WriteLine("Before ClipArticle_UnknownSite_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            string unknownSite = "unknown_site";

            Console.WriteLine("Validing site:" + unknownSite);
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1422/clip/", unknownSite);

            DateTime dt = DateTime.Now;
            String timeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");
            try
            {
                request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);

            Console.WriteLine("After ClipArticle_UnknownSite_Returns404");
        }

        [TestMethod]
        public void ClipArticle_NotLoggedInUser_Returns404()
        {
            Console.WriteLine("Before ClipArticle_NotLoggedInUser_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1422/clip/", _sitename);

            DateTime dt = DateTime.Now;
            String timeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");
            try
            {
                request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingUserCredentials.ToString(), errorData.Code);

            Console.WriteLine("After ClipArticle_NotLoggedInUser_Returns404");
        }

        /// <summary>
        /// Test CreateNamedArticle method from service
        /// </summary>
        [TestMethod]
        public void GetNamedArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetNamedArticle_ReadOnly_ReturnsValidXml");
            
            string[] names = { "Askh2g2", "Feedback", "Writing-Guidelines", "GuideML-Introduction", "Welcome" };

            foreach (var name in names)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validing Name:" + name);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/name/{1}?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetNamedArticle_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test CreateNamedArticle method from service
        /// </summary>
        [TestMethod]
        public void GetNamedArticleViaGetArticles_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetNamedArticleViaGetArticles_ReadOnly_ReturnsValidXml");

            string[] names = { "Askh2g2", "Feedback", "Writing-Guidelines", "GuideML-Introduction", "Welcome" };

            foreach (var name in names)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validing Name:" + name);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetNamedArticleViaGetArticles_ReadOnly_ReturnsValidXml");
        }

        [TestMethod]
        public void GetNamedArticle_UnknownArticle_Returns404()
        {
            Console.WriteLine("Before GetNamedArticle_UnknownArticle_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            string unknownArticle = "IAmTheUnknownArticle";

            Console.WriteLine("Validing site:" + unknownArticle);
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/name/{1}?format=xml", _sitename, unknownArticle);

            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ArticleNotFound.ToString(), errorData.Code);

            Console.WriteLine("After ClipArticle_UnknownSite_Returns404");
        }

#region SetupFunctions

        private static void SetupKeyNamedArticles()
        {
            Dictionary<string, int> namedarticles = new Dictionary<string,int>()
            { {"Feedback", 5734},
                        {"Welcome", 53146},
                        {"EditedGuide-Guidelines", 53209},
                        {"Writing-Guidelines", 53209},
                        {"Copyright", 109748},
                        {"Trademarks", 109748},
                        {"MiscChat", 121096},
                        {"Privacy", 122275},
                        {"terms", 122284},
                        {"WordOfTheDay", 142147},
                        {"Askh2g2", 148907},
                        {"GuideML-Introduction", 155701},
                        {"Smiley", 155909},
                        {"Welcome-DNA", 157349} };

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                foreach( KeyValuePair<string, int> namedarticle in namedarticles)
                {
                    String sql = String.Format("exec setkeyarticle '{0}', {1}, 1, 1", namedarticle.Key, namedarticle.Value);

                    reader.ExecuteDEBUGONLY(sql);
                }
            }
        }

        private static void SetupFullTextIndex()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("CREATE FULLTEXT CATALOG GuideEntriesCat WITH ACCENT_SENSITIVITY = OFF");
                reader.ExecuteDEBUGONLY("CREATE FULLTEXT INDEX ON dbo.GuideEntries(Subject, text) KEY INDEX PK_GuideEntries ON GuideEntriesCat WITH CHANGE_TRACKING AUTO");
            }

            //wait a bit for the cat to be filled
            System.Threading.Thread.Sleep(20000);
        }

        private static void ClearArticlesForTheLastMonthForMonthSummaryFail()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(string.Format("update guideentries set datecreated = DATEADD(month, -2, getdate()) where datecreated > DATEADD(month, -1, getdate())"));
            }
        }

        private static void SetupMonthSummaryArticle()
        {
            int entryId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {

                reader.ExecuteDEBUGONLY("SELECT TOP 1 * from guideentries where status=1 and siteid=1 ORDER BY EntryID DESC");
                if (reader.Read())
                {
                    entryId = reader.GetInt32("entryid");
                }
                if (entryId > 0)
                {
                    reader.ExecuteDEBUGONLY(string.Format("update guideentries set datecreated = getdate() where entryid={0}", entryId));
                }
            }
        }
        private String makeTimestamp()
        {
            DateTime dt = DateTime.Now;
            String timeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");
            return timeStamp;
        }
#endregion

    }
}
