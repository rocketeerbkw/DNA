using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Objects;
using BBC.Dna.Objects.Tests;
using TestUtils;
using System.Xml;
using BBC.Dna.Common;

namespace Tests
{
    /// <summary>
    /// Summary description for XmlSchemaTests
    /// </summary>
    [TestClass]
    public class DnaObjectXmlSchemaTests
    {
        /// <summary>
        /// Xml schema tests for BBC.Dna.Objects
        /// </summary>
        public DnaObjectXmlSchemaTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        /// <summary>
        ///A test for ArticleInfo Constructor
        ///</summary>
        [TestMethod()]
        public void ArticleInfoXmlTest()
        {
            ArticleInfo target = ArticleInfoTest.CreateArticleInfo();

            XmlDocument xml = Serializer.SerializeToXml(target);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "articleinfo.xsd");
            validator.Validate();

            //string json = Serializer.SerializeToJson(target);
        }

        /// <summary>
        ///A test for ForumSource Constructor
        ///</summary>
        [TestMethod()]
        public void ForumSourceXmlTest()
        {
            ForumSource target = new ForumSource();
            target.Type = ForumSourceType.Article;
            target.Article = ArticleTest.CreateArticle();
            Serializer.ValidateObjectToSchema(target, "ForumSource.xsd");
        }

        /// <summary>
        ///A test for GetRelatedClubs
        ///</summary>
        [TestMethod()]
        public void GetRelatedClubsXMLTest()
        {
            RelatedClubs clubs = RelatedClubsTest.CreateRelatedClubs();

            XmlDocument xml = Serializer.SerializeToXml(clubs);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "relatedclubs.xsd");
            validator.Validate();



        }

        /// <summary>
        ///A test for ArticleInfoPageAuthor Constructor
        ///</summary>
        [TestMethod()]
        public void ArticleInfoPageAuthorXMLTest()
        {
            ArticleInfoPageAuthor target = ArticleInfoPageAuthorTest.CreatePageAuthor();

            XmlDocument xml = Serializer.SerializeToXml(target);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "pageauthor.xsd");
            validator.Validate();
        }

        /// <summary>
        ///A test for ArticleInfoSubmittable Constructor
        ///</summary>
        [TestMethod()]
        public void ArticleInfoSubmittableXmlTest()
        {
            ArticleInfoSubmittable target = ArticleInfoSubmittableTest.Create();
            Serializer.ValidateObjectToSchema(target, "ArticleInfoSubmittable.xsd");
        }

        /// <summary>
        ///A test for SubscribeResult Constructor
        ///</summary>
        [TestMethod()]
        public void SubscribeResultXmlTest()
        {
            SubscribeResult target = SubscribeResultTest.GetSubscribeResult();
            Serializer.ValidateObjectToSchema(target, "SubscribeResult.xsd");

            //as error
            target.Value = "error occurred";
            Serializer.ValidateObjectToSchema(target, "SubscribeResult.xsd");
        }

        /// <summary>
        ///A test for ArticleInfo Constructor
        ///</summary>
        [TestMethod()]
        public void ArticleXmlTest()
        {
            Article target = ArticleTest.CreateArticle();
            Serializer.ValidateObjectToSchema(target, "article.xsd");
        }

        /// <summary>
        ///A test for CreateGuideEntry
        ///</summary>
        [TestMethod()]
        public void CreateGuideEntryXml_StandardXml_ReturnsCorrectObject()
        {
            //606 random article
            string xml = "<GUIDE><BODY>Last year Benny Howell, James Vince, Chris Morgan, Hamza Riazuddin and Tom Parsons were offered development contracts. Morgan and Parsons have been released. Howell, Vince and Riazuddin will surely be offered full contracts. Which players will get development contracts this year? Bates, Briggs and Wood must be certainties to get a contract as Burrows, Morgan and Parsons have been released. Who else? Looking at 2XI averages the two other guys that stand out for me are Luke Towers a 21 year old Australian born right handed batsmen who scored 705 runs at 64 with three hundreds and 20 year old left handed opening batsman Matt Kleinveldt who scored 917 runs with three hundreds. </BODY><ARTICLEFORUMSTYLE>1</ARTICLEFORUMSTYLE><ARTICLELINK /><ARTICLELINKTITLE /><AUTHORNAME>Martyn Smith</AUTHORNAME><AUTHORUserId>4873753</AUTHORUserId><AUTHORUSERNAME>Yardy4england</AUTHORUSERNAME><AUTOCOMPETITIONS>County cricket  </AUTOCOMPETITIONS><AUTONAMES> </AUTONAMES><COMPETITION /><DATECREATED>20091021213110</DATECREATED><EMPURL /><IMAGE /><LASTUPDATED>20091021213313</LASTUPDATED><MANAGERSPICK /><OTHERCOMPETITION /><OTHERSPORT /><OTHERSPORTUSERS /><OTHERTEAM /><POLLTYPE1>3</POLLTYPE1><SPORT>Cricket</SPORT><TEAM>Hampshire</TEAM><TYPEOFARTICLE>user article sport</TYPEOFARTICLE><YOUTUBEURL /></GUIDE>";
            XmlElement actual = GuideEntry.CreateGuideEntry(xml, 0, GuideEntryStyle.GuideML);
            Serializer.ValidateObjectToSchema(actual, "GuideML.xsd");
        }

        /// <summary>
        ///A test for CreateGuideEntry
        ///</summary>
        [TestMethod()]
        public void CreateGuideEntryXmlTest_WithEntities_ReturnsCorrectObject()
        {
            //H2G2 random article
            string xml = "<GUIDE><BODY><P>It is likely that there are many planetary systems scattered throughout our vast universe. However, the universe <I>is</I> vast - so vast that we have difficulty observing them. As such, we can only really know about our own Solar System, that is the system of objects under the primary influence of the Sun. Even here we have lots of gaps in our knowledge. How did the planets form? Why is the Sun a single star in a sky full of binary systems? Why does Jupiter have its Great Red Spot? Is there life on Europa? We have theories that try to answer some of these questions, but there is still a lot we need to learn about our own solar system, before we can start looking elsewhere.</P>  <P>Here's a brief overview overview of this fascinating system.</P>  <HEADER>The Solar System</HEADER>  <SUBHEADER>How did it get here?</SUBHEADER>  <P>The solar system probably formed from a cloud of mainly hydrogen gas, with various other heavier elements mixed in. Gravity may made part of this cloud condense enough to ignite nuclear fusion in part of it. Thus the Sun might have been born. The other matter in the nebula of gas surrounding the young star probably condensed to form protoplanets, some of which collided with each other, and some of which survived, eventually making up the planets and other bodies in the system which we see today. The composition of the planets at various distances from the Sun can be explained by the heat generated by the Sun - the planet Mercury only has a thin sillicate mantle because sillicates have difficulty existing that close to the Sun.</P>  <P>We can be pretty sure that the objects in the Solar System formed at around the same time - the Sun didn't capture planets which had already formed somewhere else.</P>  <SUBHEADER>Our Neigbours</SUBHEADER>  <P>The nearest<FOOTNOTE>Nearest on astronomical scales, not on human terms - if you shrunk the Solar System by a factor of one billion (10<SUP>9</SUP>), the Sun would be 150m from Earth, but Proxima Centauri would be 40,000km away.</FOOTNOTE> star to the Sun is Proxima Centauri, part of the <LINK H2G2=\"A132797\">Alpha Centauri</LINK> system. The Solar System is located about two thirds of the way out from the centre of the Milky Way Galaxy, on a spiral arm. Our Galaxy has two companions, the Greater and Lesser Magellanic Clouds, and, in the wider Universe, the nearest large galaxy is Andromeda, M31.</P>  <SUBHEADER><LINK H2G2=\"A356852\">The Sun (Sol)</LINK></SUBHEADER>  <P>A great star. Not too many X-rays, not too little infrared, just the right size for carbon-based life to evolve in the system. Sol is stable over long periods of time, though it's expected to start running down in about 200 million years, unless some preventative maintenance is carried out.</P>  <HEADER>The Terrestrial Planets</HEADER>  <SUBHEADER><LINK H2G2=\"A396812\">Mercury</LINK></SUBHEADER>  <P>Hot enough to boil tin on the sunward summer side, cold enough to freeze ice in the dark winter. No atmosphere. Mercury is a quite inhospitable place.</P>  <SUBHEADER><LINK H2G2=\"A396939\">Venus</LINK></SUBHEADER>  <P>Due to an out-of-control <LINK H2G2=\"A283277\">greenhouse effect</LINK>, not only is the sky constantly covered in clouds, but it rains <I>all the time</I> (not unlike England). Any visitors would have to wear comfortable rain gear which isn't dissolved by concentrated sulphuric acid. You'd think that humans would take a hint from this example just next door, since Venus is in many ways Earth's sister planet, except for the atmosphere. They don't, of course, and continue to burn fossil fuels, polluting the air and contributing to the same factors that makes Venus such a hot-house.</P>  <SUBHEADER><LINK H2G2=\"A18541\">Earth</LINK> &amp; <LINK H2G2=\"A399909\">The Moon</LINK></SUBHEADER>  <P>The Earth has got this huge satellite called the Moon, an amazing satellite that, despite not having an atmosphere, has been visited safely by humans. Both bodies dominate each other's skies, and have complicated gravitational interactions. As a result, the Earth's seas vary in height as much as two metres every rotation. The Moon's rotation has perfectly matched its orbital period (also due to these interactions) and Earth's rotation is slowing down for the same reasons.</P>  <SUBHEADER><LINK H2G2=\"A330823\">Mars</LINK></SUBHEADER>  <P>This planet has fascinated humans for centuries because it is so near. Giovanni Schiapirelli thought that he saw straight canals on Mars, which led to suspicions of intelligent life. No one really knows why Martians should be green, but that's how they're always portrayed...</P>  <SUBHEADER><LINK H2G2=\"A178517\">The Asteroid Belt</LINK></SUBHEADER>  <P>The asteroid belt constitutes a vast ring of lumps of rocks kept in order by the gravitational influences of Jupiter and Mars. Whether they are the remains of an unformed planet, an exploded planet, or just debris is not known. The belt is mostly confined to the ecliptic plane<FOOTNOTE>All the planets' orbits are in the same plane, so from the side, a diagram of the solar system's orbital paths looks flat.</FOOTNOTE>, so man-made satellites can hop over the belt on their way to the outer planets.</P>  <HEADER>The Jovian Planets</HEADER>  <SUBHEADER><LINK H2G2=\"A402003\">Jupiter</LINK></SUBHEADER>  <P>Being the biggest planet in the system, the metallic hydrogen core of Jupiter generates some pretty intense magnetic fields. It also has a system of 16 satellites, the largest of which is Ganymede. Jupiter's anomaly is its obvious storm systems, including the 'Great Red Spot'. The whorls and patterns on the upper atmosphere are well worth looking at.</P>  <SUBHEADER><LINK H2G2=\"A383960\">Saturn</LINK></SUBHEADER>  <P>Saturn has a ring system to die for, made from high-albedo<FOOTNOTE>The albedo of an object is the amount of light it reflects.</FOOTNOTE> ice, kept in place by members of its 18-satellite contingent.</P>  <SUBHEADER><LINK H2G2=\"A396713\">Uranus</LINK></SUBHEADER>  <P>Big. Blue. Weird. And the butt of some terrible jokes...</P>  <P>First, someone's knocked it over. Its axis of rotation is almost 90&deg; to the plane of the ecliptic, so its polar regions get more sun than the equator. The equator is still somehow warmer than the poles, though, and no one knows why. Alone of the four largest planets, it doesn't generate more heat than it receives, leaving it cold. To cap it all, Uranus' magnetic field is at 60&deg; to titshe axis of rotation. </P>  <P>Uranus has the most moons, too.</P>  <SUBHEADER><LINK H2G2=\"A386598\">Neptune</LINK></SUBHEADER>  <P>Neptune seems like an imitation of the weirdest features of the other three giants. It's got some twisty rings, like Saturn; it's got a storm spot like Jupiter; and it's got a tilted magnetic field like Uranus. The only <I>new</I> weird thing it adds to the broth is that the winds are unaccountably stronger than they should be.</P>  <HEADER>The Outer Reaches</HEADER>  <SUBHEADER><LINK H2G2=\"A387182\">Pluto</LINK> &amp; Charon</SUBHEADER>  <P>These two make up the the second double planet in the system, along with the Earth and the Moon, but these two are even closer in size. This has lead to <I>both</I> planets matching rotation with orbit, so the same sides face each other all the time.</P>  <P>Pluto is quite eccentric, and swaps order with Neptune every hundred years or so. And did we mention it's cold? When it wanders back out to perihelion - its furthest distance from the Sun - the atmosphere freezes and falls as snow. Take a coat.</P>  <SUBHEADER><LINK H2G2=\"A387010\">The Kuiper Belt &amp; The Oort Cloud</LINK></SUBHEADER>  <P>The Kuiper belt starts just outside the orbit of Pluto, and is in the plane of the ecliptic like the asteroid belt.</P>  <P>We don't <I>know</I> that the Oort Cloud exists. Its existance has been suggested as the source of some types of comet. It is thought to be a spherical shell completely surrounding the Solar System at a distance of about a light year, but we don't know if it is, or how it got there.</P>  <P>This is a rewrite of <LINK H2G2=\"A79508\">A79508</LINK> by <LINK H2G2=\"U28266\">Orinoco</LINK>.</P>  </BODY><REFERENCES /></GUIDE>";
            XmlElement actual = GuideEntry.CreateGuideEntry(xml, 0, GuideEntryStyle.GuideML);
            Serializer.ValidateObjectToSchema(actual, "GuideML.xsd");
        }

        /// <summary>
        ///A test for CrumbTrial Constructor
        ///</summary>
        [TestMethod()]
        public void CrumbTrailXmlTest()
        {
            CrumbTrails target = CrumbTrailsTest.CreateCrumbTrails();
            Serializer.ValidateObjectToSchema(target, "crumbtrails.xsd");
        }

        /// <summary>
        ///A test for RelatedArticle Constructor
        ///</summary>
        [TestMethod()]
        public void RelatedArticlesXmlTest()
        {
            ArticleInfoRelatedMembers relatedmembers = new ArticleInfoRelatedMembers();
            relatedmembers.RelatedArticles = RelatedArticleTest.CreateRelatedArticles();

            XmlDocument xml = Serializer.SerializeToXml(relatedmembers);
            DnaXmlValidator validator = new DnaXmlValidator(xml.DocumentElement.SelectSingleNode("RELATEDARTICLES").OuterXml, "relatedarticles.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Checks threadpost xml created
        /// </summary>
        [TestMethod()]
        public void ThreadPostXmlTest()
        {
            ThreadPost post = ThreadPostTest.CreateThreadPost();

            Serializer.ValidateObjectToSchema(post, "post.xsd");
        }

        /// <summary>
        ///A test for OnlineUsers Constructor
        ///</summary>
        [TestMethod()]
        public void OnlineUserXmlTest()
        {
            OnlineUsers target = OnlineUsersTest.GetOnlineUsers();
            Serializer.ValidateObjectToSchema(target, "OnlineUsers.xsd");

        }

        /// <summary>
        ///A test for ForumSourceClub Constructor
        ///</summary>
        [TestMethod()]
        public void ForumSourceClubXmlTest()
        {
            ForumSourceClub target = new ForumSourceClub()
            {
                Type = ForumSourceType.Club,
                Club = new Club()
                {
                    Name = ""
                }
            };
            Serializer.ValidateObjectToSchema(target, "ForumSource.xsd");

        }

        /// <summary>
        ///A test for ForumSourceJournal Constructor
        ///</summary>
        [TestMethod()]
        public void ForumSourceJournalXmlTest()
        {
            ForumSourceJournal target = new ForumSourceJournal();
            target.Type = ForumSourceType.Journal;
            target.Article = ArticleTest.CreateArticle();
            target.JournalUser = new UserElement()
            {
                user = UserTest.CreateTestUser()
            };

            Serializer.ValidateObjectToSchema(target, "ForumSource.xsd");
        }

        /// <summary>
        ///A test for ForumSourceReviewForum Constructor
        ///</summary>
        [TestMethod()]
        public void ForumSourceReviewForumXmlTest()
        {
            ForumSourceReviewForum target = new ForumSourceReviewForum();
            target.Type = ForumSourceType.Journal;
            target.Article = ArticleTest.CreateArticle();
            target.ReviewForum = ReviewForumTest.CreateReviewForum();

            Serializer.ValidateObjectToSchema(target, "ForumSource.xsd");
        }

        /// <summary>
        ///A test for Thread Constructor
        ///</summary>
        [TestMethod()]
        public void ThreadXmlTest()
        {
            ForumThreadPosts target = ThreadTest.CreateThread();
            Serializer.ValidateObjectToSchema(target, "thread.xsd");
        }

        /// <summary>
        ///A test for ThreadSummary Constructor
        ///</summary>
        [TestMethod()]
        public void ThreadSummaryXmlTest()
        {
            ThreadSummary target = ThreadSummaryTest.CreateThreadSummaryTest();
            Serializer.ValidateObjectToSchema(target, "ThreadSummary.xsd");
        }

        /// <summary>
        ///A test for SubscribeState Constructor
        ///</summary>
        [TestMethod()]
        public void SubscribeStateXmlTest()
        {
            SubscribeState target = SubscribeStateTest.GetSubscribeState();
            Serializer.ValidateObjectToSchema(target, "SubscribeState.xsd");
        }

        /// <summary>
        ///A test for userName
        ///</summary>
        [TestMethod()]
        public void UserAsXmlWithoutGroups()
        {
            User target = UserTest.CreateTestUser();
            XmlDocument xml = Serializer.SerializeToXml(target);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "user.xsd");
            validator.Validate();

        }

        /// <summary>
        ///A test for userName
        ///</summary>
        [TestMethod()]
        public void UserAsXmlWithGroups()
        {
            User target = UserTest.CreateTestUser();

            target.Groups.Add(new Group("EDITOR"));
            target.Groups.Add(new Group("MODERATOR"));
            XmlDocument xml = Serializer.SerializeToXml(target);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "user.xsd");
            validator.Validate();

        }

        /// <summary>
        ///A test for ForumThreads Constructor
        ///</summary>
        [TestMethod()]
        public void ForumThreadsXmlTest()
        {
            ForumThreads target = ForumThreadsTest.CreateForumThreadsTest();
            Serializer.ValidateObjectToSchema(target, "ForumThreads.xsd");
        }

        /// <summary>
        ///A test for ReviewForum Constructor
        ///</summary>
        [TestMethod()]
        public void ReviewForumXmlTest()
        {
            ReviewForum target = ReviewForumTest.CreateReviewForum();
            Serializer.ValidateObjectToSchema(target, "reviewforum.xsd");
        }

        /// <summary>
        /// Tests data as xml
        /// </summary>
        [TestMethod]
        public void DateAsXml()
        {

            DateTime dateTime = DateTime.Now;
            Date date = new Date(dateTime);

            XmlDocument xml = Serializer.SerializeToXml(date);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "date.xsd");
            validator.Validate();

            XmlNode local = xml.SelectSingleNode("DATE/LOCAL");
            Assert.AreEqual(local.Attributes["SECONDS"].Value, dateTime.Second.ToString());
            Assert.AreEqual(local.Attributes["MINUTES"].Value, dateTime.Minute.ToString());
            Assert.AreEqual(local.Attributes["HOURS"].Value, dateTime.Hour.ToString());
            Assert.AreEqual(local.Attributes["DAY"].Value, dateTime.Day.ToString());
            Assert.AreEqual(local.Attributes["MONTH"].Value, dateTime.Month.ToString());
            Assert.AreEqual(local.Attributes["YEAR"].Value, dateTime.Year.ToString());


            local = xml.SelectSingleNode("DATE");
            dateTime = dateTime.ToUniversalTime();
            Assert.AreEqual(local.Attributes["SECONDS"].Value, dateTime.Second.ToString());
            Assert.AreEqual(local.Attributes["MINUTES"].Value, dateTime.Minute.ToString());
            Assert.AreEqual(local.Attributes["HOURS"].Value, dateTime.Hour.ToString());
            Assert.AreEqual(local.Attributes["DAY"].Value, dateTime.Day.ToString());
            Assert.AreEqual(local.Attributes["MONTH"].Value, dateTime.Month.ToString());
            Assert.AreEqual(local.Attributes["YEAR"].Value, dateTime.Year.ToString());

        }
    }
}
