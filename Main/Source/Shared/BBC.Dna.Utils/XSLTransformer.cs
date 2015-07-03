using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;


namespace BBC.Dna.Utils
{
    /// <summary>
    /// Helper class for html mundging
    /// </summary>
    public class XSLTransformer
    {

        private static Dictionary<string, XslCompiledTransform> _cachedXslt = new Dictionary<string, XslCompiledTransform>();


        /// <summary>
        /// The MS Xslt transformer method
        /// </summary>
        /// <param name="xslFile">The name of the skin file to test</param>
        /// <param name="testXML">The xml to test against</param>
        /// <param name="numberOfErrors">A counter that will be incremented if an error occures</param>
        /// <returns>The result of the test. Possible results are XML errors, Xslt errors, File Errors and Success</returns>
        public static string TransformUsingXslt(string xslFile, XmlDocument testXML, ref int numberOfErrors)
        {
            try
            {
                XmlNodeReader xmlReader = null;
                if (testXML.FirstChild.OuterXml.IndexOf("<?xml") == 0)
                {//ignore the header in the xml document if its present
                    xmlReader = new XmlNodeReader(testXML.FirstChild.NextSibling);
                }
                else
                {
                    xmlReader = new XmlNodeReader(testXML.FirstChild);
                }
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
                    xset.DtdProcessing = DtdProcessing.Parse;
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
                    return output.ToString();
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
        }

        //public static Processor processor = new Processor();
        //private static Dictionary<string, XsltTransformer> _cachedSaxonXslt = new Dictionary<string, XsltTransformer>();
        /// <summary>
        /// The Saxon xslt2.0 transformer method
        /// </summary>
        /// <param name="xslFile">The xslt file you want to transform with</param>
        /// <param name="testXML">The xml document you want to transform against</param>
        /// <param name="numberOfErrors">The number of errors encounted</param>
        /// <returns>A report of how the transform went</returns>
        public static string TransformUsingXslt2(string xslFile, XmlDocument testXML, ref int numberOfErrors)
        {
            //not using xslt2 transforming anymore....
            return TransformUsingXslt(xslFile, testXML, ref numberOfErrors);
            //List<StaticError> errors = new List<StaticError>();
            //try
            //{
            //    string xml = testXML.InnerXml;
            //    DocumentBuilder xmlDoc = processor.NewDocumentBuilder();
            //    XdmNode xmlBaseNode = null;
            //    if (testXML.FirstChild.OuterXml.IndexOf("<?xml") == 0)
            //    {//ignore the header in the xml document if its present
            //        xmlBaseNode = xmlDoc.Build(testXML.FirstChild.NextSibling);
            //    }
            //    else
            //    {
            //        xmlBaseNode = xmlDoc.Build(testXML.FirstChild);
            //    }


            //    XsltTransformer transformer = null;
            //    if (_cachedSaxonXslt.ContainsKey(xslFile))
            //    {
            //        transformer = _cachedSaxonXslt[xslFile];
            //    }
            //    else
            //    {
            //        DocumentBuilder xsltDoc = processor.NewDocumentBuilder();
            //        XdmNode xsltBaseNode = xsltDoc.Build(new Uri(xslFile));

            //        XsltCompiler compiler = processor.NewXsltCompiler();
            //        compiler.ErrorList = errors;
            //        XsltExecutable executable = compiler.Compile(xsltBaseNode);
            //        transformer = executable.Load();
            //        _cachedSaxonXslt.Add(xslFile, transformer);// caching seems to be causing a problem on repeat
            //    }

            //    transformer.InitialContextNode = xmlBaseNode;

            //    XdmDestination output = new XdmDestination();
            //    transformer.Run(output);

            //    return output.XdmNode.OuterXml;
            //}
            //catch (Exception ex)
            //{
            //    string errorMsg = ex.Message;
            //    if (ex.InnerException != null)
            //    {
            //        errorMsg += " " + ex.InnerException.Message;
            //    }
            //    numberOfErrors++;

            //    foreach (StaticError error in errors)
            //    {
            //        errorMsg += "\n\r" + error.Message + "\n\r" + error.ModuleUri + "\n\r";
            //        numberOfErrors++;
            //    }
            //    throw new Exception(errorMsg);
            //}


        }

    }
}
