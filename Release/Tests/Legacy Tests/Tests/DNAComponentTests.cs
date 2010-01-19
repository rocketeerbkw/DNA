using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// This tests the general component level methods
    /// </summary>
    [TestClass]
    public class DnaComponentTests
    {
        /// <summary>
        /// Tests to make sure that the update relative date method does what it says :)
        /// </summary>
        [TestMethod]
        public void TestUpdatingOfRelativeDates()
        {
            // Create a dna guidentry component
            Mockery mock = new Mockery();
            IInputContext mockedContext = mock.NewMock<IInputContext>();
            GuideEntry testComponent = new GuideEntry(mockedContext, new GuideEntrySetup(5176));

            // Now create a date block in the xml
            testComponent.AddDateXml(DateTime.UtcNow.Subtract(new TimeSpan(5,5,0)),testComponent.RootElement,"TESTDATE");

            
            // Remove the Relative date attribute
            testComponent.RootElement.SelectSingleNode("//TESTDATE/DATE").Attributes.RemoveNamedItem("RELATIVE");
            Assert.IsTrue(testComponent.RootElement.SelectSingleNode("//TESTDATE/DATE").Attributes["RELATIVE"] == null, "Shouldn't have a relative date attribute at this stage!");

            // Now update the relative date attribute
            testComponent.UpdateRelativeDates();
            Assert.IsTrue(testComponent.RootElement.SelectSingleNode("//TESTDATE/DATE").Attributes["RELATIVE"] != null, "Should have a relative date attribute at this stage!");
            Assert.IsTrue(testComponent.RootElement.SelectSingleNode("//TESTDATE/DATE").Attributes["RELATIVE"].Value.CompareTo("5 Hours Ago") == 0, "The relative time should be 5 hours ago! It's " + testComponent.RootElement.SelectSingleNode("//TESTDATE/DATE").Attributes["RELATIVE"].Value);
        }

		/// <summary>
		/// Test the helper function MakeLinkFromURLs
		/// </summary>
		[TestMethod]
		public void TestMakeLinksFromUrls()
		{
			XmlDocument doc = new XmlDocument();
			doc.LoadXml(@"<H2G2>
  <POST ID='1234'>
    <TEXT POSTSTYLE='1'>
      <RICHTEXT>
        This is <B>bold text</B> and http://www.bbc.co.uk that was a hyperlink
        <BR />
        <I>http://www.google.com</I>
        <BR/>
        <I>before not after http://www.h2g2.com/</I>
        <I>http://www.bbc.co.uk and some text after</I>
		<I>some text http://www.bbc.co.uk/dna/h2g2/F19585 with two links http://www.bbc.co.uk/doctorwho/ in it</I>
		<I>http://www.bbc.co.uk/dna/h2g2/F19585 with two links http://www.bbc.co.uk/doctorwho/ in it</I>
		<I>some text http://www.bbc.co.uk/dna/h2g2/F19585 with two links http://www.bbc.co.uk/doctorwho/</I>
		<I>http://www.bbc.co.uk/dna/h2g2/F19585 http://www.bbc.co.uk/doctorwho/</I>
      </RICHTEXT>
    </TEXT>
  </POST>
</H2G2>");
			XmlNodeList textnodes = doc.SelectNodes("//TEXT[@POSTSTYLE='1']");
			Assert.IsNotNull(textnodes, "Failed to find nodes for testing");
			Assert.IsTrue(textnodes.Count == 1, "Failed to find matching nodes for testing");
			XmlNode textnode = textnodes[0];
			XmlNodeList nodes = textnode.SelectNodes(".//text()[contains(.,'http')]");
			Assert.IsTrue(nodes.Count == 8, "Should find five matching textnodes");
			Assert.IsTrue(nodes[0] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[1] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[2] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[3] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[4] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[5] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[6] is XmlText, "Types don't match");
			Assert.IsTrue(nodes[7] is XmlText, "Types don't match");
			Assert.AreEqual(@" and http://www.bbc.co.uk that was a hyperlink
        ", ((XmlText)nodes[0]).Value, "Text doesn't match");
			Assert.AreEqual(@"http://www.google.com", ((XmlText)nodes[1]).Value, "Text doesn't match");
			Assert.AreEqual(@"before not after http://www.h2g2.com/", ((XmlText)nodes[2]).Value, "Text doesn't match");
			Assert.AreEqual(@"http://www.bbc.co.uk and some text after", ((XmlText)nodes[3]).Value, "Text doesn't match");
			// Now munge each one

			XmlNode node = nodes[0];

			XmlNode parent = node.ParentNode;
			XmlNode prevSibling = node.PreviousSibling;
			XmlNode nextSibling = node.NextSibling;

			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNotNull(node.PreviousSibling, "Previous sibling is null");
			Assert.IsNotNull(node.NextSibling, "Next Sibling is null");
			Assert.IsTrue(node.PreviousSibling.Name == "B", "Expected bold element before");
			Assert.IsTrue(node.NextSibling.Name == "BR", "Expected br element after");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.IsTrue(node.ParentNode == parent, "Node is still in tree");
			Assert.IsTrue(node.PreviousSibling == prevSibling, "Node is still at same sibling place");
			Assert.IsFalse(node.NextSibling == nextSibling, "Next node should be an inserted node");
			XmlNode newNext = node.NextSibling;
			CheckLinkElement(newNext, "http://www.bbc.co.uk");
			Assert.AreEqual(" and ", (node as XmlText).Value, "Original node isn't truncated");
			Assert.IsTrue(newNext.NextSibling is XmlText, "Other half of text not found after link");
			Assert.AreEqual(newNext.NextSibling.Value, @" that was a hyperlink
        ", "Following text not found");


			// <I>before not after http://www.h2g2.com/</I>
			node = nodes[2];

			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;

			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.IsTrue(node.ParentNode == parent, "Node is still in tree");
			Assert.IsTrue(node.PreviousSibling == null, "Node is still at same sibling place");
			Assert.IsFalse(node.NextSibling == null, "Next node should be an inserted node");
			newNext = node.NextSibling;
			CheckLinkElement(newNext, "http://www.h2g2.com/");
			Assert.AreEqual("before not after ", (node as XmlText).Value, "Original node isn't truncated");
			Assert.IsNull(newNext.NextSibling, "Next sibling after link should be null");

			// <I>http://www.bbc.co.uk and some text after</I>
			node = nodes[3];

			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;

			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.IsTrue(node.ParentNode == parent, "Node is still in tree");
			Assert.IsFalse(node.PreviousSibling == null, "Node should now have previous sibling");
			Assert.IsTrue(node.NextSibling == null, "Next node should still be null");
			newNext = node.PreviousSibling;
			CheckLinkElement(newNext, "http://www.bbc.co.uk");
			Assert.AreEqual(" and some text after", (node as XmlText).Value, "Original node isn't truncated");
			Assert.IsNull(newNext.PreviousSibling, "link should be first child");

			// Now the next one
			// <I>http://www.google.com</I>

			node = nodes[1];

			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;

			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.IsTrue(node.ParentNode == null, "Node removed from tree");
			newNext = parent.FirstChild;
			CheckLinkElement(newNext, "http://www.google.com");
			Assert.IsNull(newNext.PreviousSibling, "Previous sibling of new node isn't null");
			Assert.IsNull(newNext.NextSibling, "Next sibling of new node isn't null");

			// <I>some text http://www.bbc.co.uk/dna/h2g2/F19585 with two links http://www.bbc.co.uk/doctorwho/ in it</I>
			node = nodes[4];
			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;
			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.AreSame(parent, node.ParentNode, "Node is still in tree");
			Assert.AreEqual(parent.ChildNodes.Count, 5, "Expecting three child nodes");
			XmlNodeList children = parent.ChildNodes;
			Assert.IsTrue(children[0] is XmlText, "Expecting text node first");
			Assert.IsTrue(children[1] is XmlElement, "Expecting Element second");
			Assert.IsTrue(children[2] is XmlText, "Expecting text node third");
			Assert.IsTrue(children[3] is XmlElement, "Expecting Element node fourth");
			Assert.IsTrue(children[4] is XmlText, "Expecting text node fifth");
			Assert.AreEqual(children[0].Value, "some text ", "Wrong truncated text for first element");
			Assert.AreEqual(children[2].Value, " with two links ", "Wrong truncated text for middle element");
			Assert.AreEqual(children[4].Value, " in it", "Wrong truncated text for last element");
			CheckLinkElement(children[1], "http://www.bbc.co.uk/dna/h2g2/F19585");
			CheckLinkElement(children[3], "http://www.bbc.co.uk/doctorwho/");

			// <I>http://www.bbc.co.uk/dna/h2g2/F19585 with two links http://www.bbc.co.uk/doctorwho/ in it</I>

			node = nodes[5];
			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;
			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.AreSame(parent, node.ParentNode, "Node is still in tree");
			Assert.AreEqual(parent.ChildNodes.Count, 4, "Expecting three child nodes");
			children = parent.ChildNodes;
			Assert.IsTrue(children[0] is XmlElement, "Expecting Element second");
			Assert.IsTrue(children[1] is XmlText, "Expecting text node third");
			Assert.IsTrue(children[2] is XmlElement, "Expecting Element node fourth");
			Assert.IsTrue(children[3] is XmlText, "Expecting text node fifth");
			Assert.AreEqual(children[1].Value, " with two links ", "Wrong truncated text for middle element");
			Assert.AreEqual(children[3].Value, " in it", "Wrong truncated text for last element");
			CheckLinkElement(children[0], "http://www.bbc.co.uk/dna/h2g2/F19585");
			CheckLinkElement(children[2], "http://www.bbc.co.uk/doctorwho/");
			
			
			// <I>some text http://www.bbc.co.uk/dna/h2g2/F19585 with two links http://www.bbc.co.uk/doctorwho/</I>

			node = nodes[6];
			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;
			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.AreSame(parent, node.ParentNode, "Node is still in tree");
			Assert.AreEqual(parent.ChildNodes.Count, 4, "Expecting three child nodes");
			children = parent.ChildNodes;
			Assert.IsTrue(children[0] is XmlText, "Expecting Element second");
			Assert.IsTrue(children[1] is XmlElement, "Expecting text node third");
			Assert.IsTrue(children[2] is XmlText, "Expecting Element node fourth");
			Assert.IsTrue(children[3] is XmlElement, "Expecting text node fifth");
			Assert.AreEqual(children[0].Value, "some text ", "Wrong truncated text for middle element");
			Assert.AreEqual(children[2].Value, " with two links ", "Wrong truncated text for last element");
			CheckLinkElement(children[1], "http://www.bbc.co.uk/dna/h2g2/F19585");
			CheckLinkElement(children[3], "http://www.bbc.co.uk/doctorwho/");

			// <I>http://www.bbc.co.uk/dna/h2g2/F19585 http://www.bbc.co.uk/doctorwho/</I>

			node = nodes[7];
			parent = node.ParentNode;
			prevSibling = node.PreviousSibling;
			nextSibling = node.NextSibling;
			Assert.IsNotNull(node.ParentNode, "Parent node is null");
			Assert.IsNull(node.PreviousSibling, "Previous sibling is not null");
			Assert.IsNull(node.NextSibling, "Next Sibling is not null");
			Assert.IsTrue(node.ParentNode.Name == "I", "Expected I element as parent");
			DnaComponent.MakeLinksFromUrls(node);
			Assert.AreSame(parent, node.ParentNode, "Node is still in tree");
			Assert.AreEqual(parent.ChildNodes.Count, 3, "Expecting three child nodes");
			children = parent.ChildNodes;
			Assert.IsTrue(children[0] is XmlElement, "Expecting text node third");
			Assert.IsTrue(children[1] is XmlText, "Expecting Element node fourth");
			Assert.IsTrue(children[2] is XmlElement, "Expecting text node fifth");
			Assert.AreEqual(children[1].Value, " ", "Wrong truncated text for middle element");
			CheckLinkElement(children[0], "http://www.bbc.co.uk/dna/h2g2/F19585");
			CheckLinkElement(children[2], "http://www.bbc.co.uk/doctorwho/");

		}

		private void CheckLinkElement(XmlNode newNext, string url)
		{
			Assert.IsTrue(newNext.Name == "LINK", "New next node isn't a link");
			Assert.AreEqual(url, newNext.InnerText, "Link node has wrong contents");
			XmlElement link = newNext as XmlElement;
			Assert.IsNotNull(link, "Next node isn't element type");
			Assert.AreEqual(link.GetAttribute("HREF"), url, "HREF attribute missing");
		}
    }
}
