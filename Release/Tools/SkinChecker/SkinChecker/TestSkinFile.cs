using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using Saxon.Api;

namespace SkinsChecker
{
    public class TestSkinFile
    {
        private Dictionary<string, string> _cachedXML = new Dictionary<string, string>();
        private Dictionary<string, XslCompiledTransform> _cachedXslt = new Dictionary<string, XslCompiledTransform>();
        private Dictionary<string, XsltTransformer> _cachedSaxonXslt = new Dictionary<string, XsltTransformer>();
        private bool _xslt2 = false;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="xslt2">A flag that states whether or not to use xslt 2.0 tranforms instead of 1.0</param>
        public TestSkinFile(bool xslt2)
        {
            _xslt2 = xslt2;
        }

        /// <summary>
        /// run the tests against the given xslt file and supplied XML
        /// </summary>
        /// <param name="xslFile">The skin file you want to test against</param>
        /// <param name="xml">The supplied xml to test the skins against</param>
        /// <param name="numberOfErrors">A counter that will be incremented if an error occures</param>
        /// <returns>The result of the test</returns>
        public string RunTestsWithSuppliedXML(string xslFile, string xml, ref int numberOfErrors)
        {
            return RunTests(xslFile, xml, ref numberOfErrors);
        }

        /// <summary>
        /// Run the tests against the given xslt file against the XML in the xml file
        /// </summary>
        /// <param name="xslFile">The skin file you want to test</param>
        /// <param name="xmlFile">The xml file that contains the xml to test the skin with</param>
        /// <param name="numberOfErrors">A counter that will be incremented if an error occures</param>
        /// <returns>The result of the test</returns>
        public string RunTestsWithXMLFile(string xslFile, string xmlFile, ref int numberOfErrors)
        {
            string result = "";
            try
            {
                // Check to see if we've cached the xml file?
                string xml = "";
                if (_cachedXML.ContainsKey(xmlFile))
                {
                    // Use the cached version
                    xml = _cachedXML[xmlFile];
                }
                else
                {
                    // Create the XML and cache it
                    if (xmlFile.Contains(".xml"))
                    {
                        xml = File.ReadAllText(xmlFile);
                    }
                    else
                    {
                        RequestXMLPage page = new RequestXMLPage();
                        if (!page.RequestDnaPage(xmlFile, ref xml, ref result))
                        {
                            return result;
                        }
                    }
                    _cachedXML.Add(xmlFile, xml);
                }
                result = RunTests(xslFile, xml, ref numberOfErrors);
            }
            catch (Exception ex)
            {
                result = "Run with xml file failed - " + ex.Message;
            }

            return result;
        }

        /// <summary>
        /// Runs the test against the xslt with supplied xml.
        /// </summary>
        /// <param name="xslFile">The name of the skin file to test</param>
        /// <param name="xml">The xml to test against</param>
        /// <param name="numberOfErrors">A counter that will be incremented if an error occures</param>
        /// <returns>The result of the test. Possible results are XML errors, Xslt errors, File Errors and Success</returns>
        private string RunTests(string xslFile, string xml, ref int numberOfErrors)
        {
            // Check to see which version of the transformer we want to use
            if (_xslt2)
            {
                return TransformUsingXslt2(xslFile, xml, ref numberOfErrors);
            }
            else
            {
                return MSXSLTTransformer(xslFile, xml, ref numberOfErrors);
            }
        }

        /// <summary>
        /// The MS Xslt transformer method
        /// </summary>
        /// <param name="xslFile">The name of the skin file to test</param>
        /// <param name="xml">The xml to test against</param>
        /// <param name="numberOfErrors">A counter that will be incremented if an error occures</param>
        /// <returns>The result of the test. Possible results are XML errors, Xslt errors, File Errors and Success</returns>
        private string MSXSLTTransformer(string xslFile, string xml, ref int numberOfErrors)
        {
            try
            {
                XmlDocument testXML = new XmlDocument();
                testXML.LoadXml(xml);
                XmlNodeReader xmlReader = new XmlNodeReader(testXML.FirstChild);
                XPathDocument xdoc = new XPathDocument(xmlReader);
                XPathNavigator xnav = xdoc.CreateNavigator();
                XslCompiledTransform transformer = null;

                // Check to see if we've already cached this xslt transform
                if (_cachedXslt.ContainsKey(xslFile))
                {
                    // Get the cached transform
                    transformer = _cachedXslt[xslFile];
                }
                else
                {
                    // Create a new transform
                    transformer = new XslCompiledTransform(false /* xsltDebugging*/);

                    // this stuff is necessary to cope with our stylesheets having DTDs
                    // Without all this settings and resolver stuff, you can't use the Load method
                    // and tell it to allow DTDs
                    XmlReaderSettings xset = new XmlReaderSettings();
                    xset.ProhibitDtd = false;
                    using (XmlReader xread = XmlReader.Create(xslFile, xset))
                    {
                        try
                        {
                            transformer.Load(xread, XsltSettings.TrustedXslt, new XmlUrlResolver());
                        }
                        catch (Exception e)
                        {
                            Type exceptionType = e.GetType();
                            if (exceptionType.Name == "XslLoadException")
                            {
                                int lineNumber = (int)exceptionType.GetMethod("get_LineNumber").Invoke(e, null);
                                int linePosition = (int)exceptionType.GetMethod("get_LinePosition").Invoke(e, null);
                                string fileName = (string)exceptionType.GetMethod("get_SourceUri").Invoke(e, null);
                                throw new XsltException(fileName + " at line " + lineNumber + ", position " + linePosition, e);
                            }
                            else
                            {
                                throw new XsltException("Compilation Error in " + xslFile, e);
                            }
                        }
                    }

                    _cachedXslt.Add(xslFile, transformer);
                }

                StringWriter output = new StringWriter();
                try
                {
                    transformer.Transform(xnav, null, output);
                    output.Close();
                }
                catch (Exception ex)
                {
                    throw new Exception("Transform did not produce any output.", ex);
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " " + ex.InnerException.Message;
                }
                numberOfErrors++;
                return error;
            }

            return "Transform completed without errors.";
        }

        /// <summary>
        /// The Saxon xslt2.0 transformer method
        /// </summary>
        /// <param name="xslFile">The xslt file you want to transform with</param>
        /// <param name="xml">The xml you want to transform against</param>
        /// <param name="numberOfErrors">The number of errors encounted</param>
        /// <returns>A report of how the transform went</returns>
        private string TransformUsingXslt2(string xslFile, string xml, ref int numberOfErrors)
        {
            List<StaticError> errors = new List<StaticError>();
            try
            {
                Processor processor = new Processor();
                DocumentBuilder xmlDoc = processor.NewDocumentBuilder();
                XmlDocument testXML = new XmlDocument();
                testXML.LoadXml(xml);
                XdmNode xmlBaseNode = xmlDoc.Build(testXML.FirstChild);

                XsltTransformer transformer = null;
                if (_cachedSaxonXslt.ContainsKey(xslFile))
                {
                    transformer = _cachedSaxonXslt[xslFile];
                }
                else
                {
                    DocumentBuilder xsltDoc = processor.NewDocumentBuilder();
                    XdmNode xsltBaseNode = xsltDoc.Build(new Uri(xslFile));

                    XsltCompiler compiler = processor.NewXsltCompiler();
                    compiler.ErrorList = errors;
                    XsltExecutable executable = compiler.Compile(xsltBaseNode);
                    transformer = executable.Load();
                }

                transformer.InitialContextNode = xmlBaseNode;

                XdmDestination output = new XdmDestination();
                transformer.Run(output);

                _cachedSaxonXslt.Add(xslFile, transformer);
            }
            catch (Exception ex)
            {
                string errorMsg = ex.Message;
                if (ex.InnerException != null)
                {
                    errorMsg += " " + ex.InnerException.Message;
                }
                numberOfErrors++;

                foreach (StaticError error in errors)
                {
                    errorMsg += "\n\r" + error.Message + "\n\r" + error.ModuleUri + "\n\r";
                    numberOfErrors++;
                }

                return errorMsg;
            }
            
            return "Transform completed without errors.";
        }
    }
}
