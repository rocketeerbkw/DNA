using System.Xml;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace BBC.Dna.Objects.Tests
{
 
 
     /// <summary>
     ///This is a test class for GuideEntryTest and is intended
     ///to contain all GuideEntryTest Unit Tests
     ///</summary>
     [TestClass()]
     public class GuideEntryTest
     {
         [TestMethod]
         public void GuideEntryTest_ValidGuidemlWithAnchors_CorrectlyParses()
         {

             var text = @"<GUIDE><BODY>This is your place for technical discussion of BBC iPlayer's TV streams across the range of devices that can access BBC iPlayer, suggestions for the future and feedback about TV within BBC iPlayer.<BR /><BR />We monitor the messageboard, but we can't guarantee to answer every query. This thread is mainly for you to talk with other users - if you need further help please see our <A HREF=""http://iplayerhelp.external.bbc.co.uk/"">searchable FAQ pages</A>. We can't help you with problems on specific programmes, so see <A HREF=""http://iplayerhelp.external.bbc.co.uk/help/about_iplayer/tech_report"">our guide on how to report a problem with a programme</A> instead.<BR /><BR />If you do discuss technical problems, other users typically find the following information useful:<BR /><BR />- The programme name, broadcast station, time and date and BBC iPlayer URL<BR />- Your browser<BR />- Your operating system or device<BR />- Whether it's BBC iPlayer streaming, BBC iPlayer Desktop, or Windows Media Player downloads</BODY></GUIDE>";
             var element = GuideEntry.CreateGuideEntry(text, 0, GuideEntryStyle.GuideML, 1);

             Assert.AreEqual(text, element.OuterXml);


         }
      


      

          static public string CreateBlankEntry()
          {
                return "<GUIDE><BODY></BODY></GUIDE>";

          }
     }
}
