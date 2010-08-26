using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
 

namespace FunctionalTests
{
    /// <summary>
    /// Issue Post Request.
    /// </summary>
    [TestClass]
    public class RequestParametersTests
    {
        /// <summary>
        /// Does a popst request with duplicate parameters.
        /// </summary>
        [TestMethod]
        public void DuplicatePostParams()
        {
            Console.WriteLine("DuplicatePostParams");
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");

            Queue<KeyValuePair<string, string>> postparams = new Queue<KeyValuePair<string, string> >();
            postparams.Enqueue(new KeyValuePair<string,string>("s_param", "1,1"));
            postparams.Enqueue(new KeyValuePair<string,string>("s_param", "2,2"));
            postparams.Enqueue(new KeyValuePair<string,string>("s_param", "3,3"));
            request.RequestPage("acs?skin=purexml", postparams);

            string paramvalue = "1,1,2,2,3,3";
            XmlDocument doc = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2CommentBoxFlat.xsd");
            validator.Validate();

            validator = new DnaXmlValidator(doc.SelectSingleNode(@"H2G2/PARAMS").OuterXml, "Params.xsd");
            validator.Validate();

            XmlNodeList nodes = doc.SelectNodes(@"H2G2/PARAMS/PARAM");
            foreach (XmlNode node in nodes)
            {
                Assert.AreEqual(paramvalue, node.SelectSingleNode("VALUE").InnerText);
            }
        }
             

        /// <summary>
        /// Does a get request featuring duplicate parameters.
        /// </summary>
        [TestMethod]
        public void DuplicateGetParams()
        {
            Console.WriteLine("DuplicateGetParams");
            string paramvalue = "1,1,2,2,3,3";
            DnaTestURLRequest test = new DnaTestURLRequest("haveyoursay");
            test.RequestPage("acs?skin=purexml&s_param=1,1&s_param=2,2&s_param=3,3");
            XmlDocument doc = test.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2CommentBoxFlat.xsd");
            validator.Validate();

            validator = new DnaXmlValidator(doc.SelectSingleNode(@"H2G2/PARAMS").OuterXml, "Params.xsd");
            validator.Validate();

            XmlNodeList nodes = doc.SelectNodes(@"H2G2/PARAMS/PARAM");
            foreach (XmlNode node in nodes)
            {
                Assert.AreEqual(paramvalue,node.SelectSingleNode("VALUE").InnerText);
            }
        }

        /// <summary>
        /// Posts a multipart/form-data request simulating a form including a <input type="form"/> element.
        /// </summary>
        [TestMethod]
        public void FileUploadRequest()
        {
            Console.WriteLine("FileUploadRequest");
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");

            Queue<KeyValuePair<string, string>> postparams = new Queue<KeyValuePair<string, string>>();
            postparams.Enqueue(new KeyValuePair<string, string>("skin", "purexml"));
            postparams.Enqueue(new KeyValuePair<string, string>("s_param", "1,1"));
            postparams.Enqueue(new KeyValuePair<string, string>("s_param", "2,2"));
            postparams.Enqueue(new KeyValuePair<string, string>("s_param", "3,3"));
            
            string uploadfile;// set to file to upload
            uploadfile = GetTestFile();

            //everything except upload file and url can be left blank if needed
            request.UploadFileEx(uploadfile, "acs", "image/jpeg",postparams,new CookieContainer());


            //Check Parameters parsed OK.
            string paramvalue = "1,1,2,2,3,3";
            XmlDocument doc = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2CommentBoxFlat.xsd");
            validator.Validate();

            validator = new DnaXmlValidator(doc.SelectSingleNode(@"H2G2/PARAMS").OuterXml, "Params.xsd");
            validator.Validate();

            XmlNodeList nodes = doc.SelectNodes(@"H2G2/PARAMS/PARAM");
            foreach (XmlNode node in nodes)
            {
                Assert.AreEqual(paramvalue, node.SelectSingleNode("VALUE").InnerText);
            }
        }

        /// <summary>
        /// Retrieves or creates a test file
        /// </summary>
        /// <returns></returns>
        private string GetTestFile()
        {
            
            //check if file exists...
            FileInfo file = new FileInfo(TestConfig.GetConfig().GetRipleyServerPath() + "test.jpg");
            if (!file.Exists)
            {
                StreamWriter sw = file.CreateText();
                for(int i=0; i < 100;i++)
                {
                    sw .WriteLine("this is test data and not a real jpg");
                }
                sw.Flush();
                sw.Close();
            }
            return file.FullName;

        }
    }
}
